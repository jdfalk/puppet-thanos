#!/usr/bin/env python3
# file: scripts/doc_update_manager.py
# version: 2.1.0
# guid: 9e8d7c6b-5a49-3827-1605-4f3e2d1c0b9a

"""
Enhanced Documentation Update Manager

This script processes JSON-based documentation update files and applies them
to target documentation files. It supports various update modes and provides
comprehensive logging and error handling.

Usage:
    python doc_update_manager.py [options]
    python doc_update_manager.py --updates-dir .github/doc-updates
    python doc_update_manager.py --dry-run --verbose
"""

import argparse
import json
import logging
import re
import shutil
import sys
from pathlib import Path
from typing import Any, Dict, Optional

# Configure logging
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)


class DocumentationUpdateManager:
    """Manages processing of documentation update files."""

    def __init__(
        self,
        updates_dir: str = ".github/doc-updates",
        cleanup: bool = True,
        dry_run: bool = False,
        verbose: bool = False,
        continue_on_error: bool = True,
    ):
        self.updates_dir = Path(updates_dir)
        self.cleanup = cleanup
        self.dry_run = dry_run
        self.verbose = verbose
        self.continue_on_error = continue_on_error

        # Create error isolation directories
        self.processed_dir = self.updates_dir / "processed"
        self.malformed_dir = self.updates_dir / "malformed"
        self.failed_dir = self.updates_dir / "failed"

        # Ensure directories exist
        for dir_path in [self.processed_dir, self.malformed_dir, self.failed_dir]:
            dir_path.mkdir(parents=True, exist_ok=True)

        self.stats = {
            "files_processed": 0,
            "files_malformed": 0,
            "files_failed": 0,
            "changes_made": False,
            "files_updated": [],
            "errors": [],
            "malformed_files": [],
            "failed_files": [],
        }

        if verbose:
            logger.setLevel(logging.DEBUG)

    def process_all_updates(self) -> Dict[str, Any]:
        """Process all update files in the updates directory with individual error handling."""
        logger.info(f"🔄 Processing documentation updates from {self.updates_dir}")

        if not self.updates_dir.exists():
            logger.info(f"📝 Updates directory does not exist: {self.updates_dir}")
            return self.stats

        # Find only files in main directory (not subdirectories)
        update_files = [f for f in self.updates_dir.glob("*.json") if f.is_file()]
        if not update_files:
            logger.info("📝 No update files found")
            return self.stats

        logger.info(f"📊 Found {len(update_files)} update files")

        # Process files in order (oldest first based on filename/timestamp)
        update_files.sort()

        # Process each file individually with error isolation
        for update_file in update_files:
            self._process_single_file_safely(update_file)

        # Save statistics
        self._save_stats()
        self._log_processing_summary()

        return self.stats

    def process_update_file(self, update_file: Path) -> None:
        """Process a single update file."""
        logger.debug(f"🔍 Processing: {update_file}")

        try:
            with open(update_file, encoding="utf-8") as f:
                update_data = json.load(f)
        except (OSError, json.JSONDecodeError) as e:
            raise Exception(f"Failed to read update file: {e}")

        # Validate required fields
        required_fields = ["file", "mode", "content"]
        for field in required_fields:
            if field not in update_data:
                raise Exception(f"Missing required field: {field}")

        target_file = Path(update_data["file"])
        mode = update_data["mode"]
        content = update_data["content"]
        options = update_data.get("options", {})

        logger.info(f"📝 Updating {target_file} (mode: {mode})")

        if self.dry_run:
            logger.info(f"🧪 [DRY RUN] Would update {target_file}")
            self.stats["files_processed"] += 1
            return

        # Apply the update
        success = self._apply_update(target_file, mode, content, options)

        if success:
            self.stats["files_processed"] += 1
            self.stats["changes_made"] = True
            if str(target_file) not in self.stats["files_updated"]:
                self.stats["files_updated"].append(str(target_file))

            # Move processed file if cleanup is enabled
            if self.cleanup:
                self._archive_processed_file(update_file)

    def _apply_update(
        self, target_file: Path, mode: str, content: str, options: Dict
    ) -> bool:
        """Apply an update to a target file."""
        try:
            # Create target file if it doesn't exist
            if not target_file.exists():
                target_file.parent.mkdir(parents=True, exist_ok=True)
                target_file.touch()
                logger.info(f"📄 Created new file: {target_file}")

            # Read current content
            try:
                with open(target_file, encoding="utf-8") as f:
                    current_content = f.read()
            except UnicodeDecodeError:
                # Try with different encoding
                with open(target_file, encoding="latin-1") as f:
                    current_content = f.read()

            # Apply update based on mode
            new_content = self._apply_mode(current_content, mode, content, options)

            if new_content != current_content:
                # Write updated content
                with open(target_file, "w", encoding="utf-8") as f:
                    f.write(new_content)
                logger.info(f"✅ Updated {target_file}")
                return True
            else:
                logger.info(f"📄 No changes needed for {target_file}")
                return False

        except Exception as e:
            error_msg = f"Failed to apply update to {target_file}: {str(e)}"
            logger.error(error_msg)
            self.stats["errors"].append(error_msg)
            return False

    def _apply_mode(
        self, current_content: str, mode: str, content: str, options: Dict
    ) -> str:
        """Apply content update based on the specified mode."""

        if mode == "append":
            return current_content + "\n" + content if current_content else content

        elif mode == "prepend":
            return content + "\n" + current_content if current_content else content

        elif mode == "replace":
            return content

        elif mode == "replace-section":
            section = options.get("section")
            if not section:
                raise ValueError("replace-section mode requires 'section' option")
            return self._replace_section(current_content, section, content)

        elif mode == "insert-after":
            after_text = options.get("after")
            if not after_text:
                raise ValueError("insert-after mode requires 'after' option")
            return self._insert_after(current_content, after_text, content)

        elif mode == "insert-before":
            before_text = options.get("before")
            if not before_text:
                raise ValueError("insert-before mode requires 'before' option")
            return self._insert_before(current_content, before_text, content)

        elif mode == "changelog-entry":
            return self._add_changelog_entry(current_content, content)

        elif mode == "task-add":
            return self._add_todo_task(current_content, content)

        elif mode == "task-complete":
            task_id = options.get("task_id")
            return self._complete_todo_task(current_content, content, task_id)

        elif mode == "update-badge":
            badge_name = options.get("badge_name")
            if not badge_name:
                raise ValueError("update-badge mode requires 'badge_name' option")
            return self._update_badge(current_content, badge_name, content)

        else:
            raise ValueError(f"Unknown update mode: {mode}")

    def _replace_section(self, content: str, section: str, new_content: str) -> str:
        """Replace a specific section in the content."""
        # Pattern to match markdown sections
        pattern = rf"(^#{1, 6}\s+{re.escape(section)}\s*$.*?)(?=^#{1, 6}\s+|\Z)"

        if re.search(pattern, content, re.MULTILINE | re.DOTALL):
            return re.sub(
                pattern,
                f"# {section}\n\n{new_content}\n",
                content,
                flags=re.MULTILINE | re.DOTALL,
            )
        else:
            # Section doesn't exist, append it
            return content + f"\n\n# {section}\n\n{new_content}\n"

    def _insert_after(self, content: str, after_text: str, new_content: str) -> str:
        """Insert content after specified text."""
        if after_text in content:
            return content.replace(after_text, after_text + "\n" + new_content)
        else:
            # If text not found, append to end
            return content + "\n" + new_content

    def _insert_before(self, content: str, before_text: str, new_content: str) -> str:
        """Insert content before specified text."""
        if before_text in content:
            return content.replace(before_text, new_content + "\n" + before_text)
        else:
            # If text not found, prepend to beginning
            return new_content + "\n" + content

    def _add_changelog_entry(self, content: str, entry: str) -> str:
        """Add entry to changelog under [Unreleased] section."""
        unreleased_pattern = r"(## \[Unreleased\].*?\n)(.*?)(?=\n## |\Z)"

        match = re.search(unreleased_pattern, content, re.DOTALL)
        if match:
            # Insert entry in unreleased section
            return content.replace(
                match.group(0), match.group(1) + "\n" + entry + "\n" + match.group(2)
            )
        else:
            # No unreleased section, add it
            unreleased_section = f"""## [Unreleased]

{entry}

"""
            # Find the first version section and insert before it
            version_pattern = r"(## \[[\d\.]+\])"
            if re.search(version_pattern, content):
                return re.sub(
                    version_pattern, unreleased_section + r"\1", content, count=1
                )
            else:
                # No version sections, append to end
                return content + "\n" + unreleased_section

    def _add_todo_task(self, content: str, task: str) -> str:
        """Add a task to TODO list."""
        # Find the first incomplete task section or append to end
        return content + "\n" + task + "\n"

    def _complete_todo_task(
        self, content: str, task_description: str, task_id: Optional[str]
    ) -> str:
        """Mark a TODO task as complete."""

        def mark_complete(match):
            return match.group(0).replace("[ ]", "[x]")

        if task_id:
            # Find task by ID and mark complete
            pattern = rf"- \[ \] .*{re.escape(task_id)}.*"
            return re.sub(pattern, mark_complete, content)
        else:
            # Find task by description and mark complete
            pattern = rf"- \[ \] .*{re.escape(task_description)}.*"
            return re.sub(pattern, mark_complete, content)

    def _update_badge(self, content: str, badge_name: str, badge_content: str) -> str:
        """Update or add a badge in README."""
        # This is a simplified implementation
        # In practice, you'd want more sophisticated badge updating
        return content + f"\n{badge_content}\n"

    def _move_to_processed(self, update_file: Path) -> None:
        """Move successfully processed file to processed directory."""
        try:
            from datetime import datetime
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            processed_name = f"{timestamp}_{update_file.name}"
            processed_path = self.processed_dir / processed_name

            shutil.move(str(update_file), str(processed_path))
            logger.debug(f"📦 Moved to processed: {processed_name}")
        except Exception as e:
            logger.warning(f"Failed to move {update_file.name} to processed: {e}")

    def _move_to_malformed(self, update_file: Path, error_msg: str) -> None:
        """Move malformed file to malformed directory with error info."""
        logger.warning(f"⚠️ Malformed file: {update_file.name} - {error_msg}")

        self.stats["files_malformed"] += 1
        self.stats["malformed_files"].append(update_file.name)
        self.stats["errors"].append(f"Malformed file {update_file.name}: {error_msg}")

        try:
            from datetime import datetime
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            malformed_name = f"{timestamp}_{update_file.name}"
            malformed_path = self.malformed_dir / malformed_name

            # Create error info file
            error_file = self.malformed_dir / f"{timestamp}_{update_file.stem}_error.txt"
            with open(error_file, "w", encoding="utf-8") as f:
                f.write(f"File: {update_file.name}\n")
                f.write(f"Error: {error_msg}\n")
                f.write(f"Timestamp: {datetime.now().isoformat()}\n")

            shutil.move(str(update_file), str(malformed_path))
            logger.debug(f"� Moved to malformed: {malformed_name}")
        except Exception as e:
            logger.warning(f"Failed to move {update_file.name} to malformed: {e}")

    def _move_to_failed(self, update_file: Path, error_msg: str) -> None:
        """Move failed file to failed directory with error info."""
        logger.warning(f"❌ Failed file: {update_file.name} - {error_msg}")

        self.stats["files_failed"] += 1
        self.stats["failed_files"].append(update_file.name)
        self.stats["errors"].append(f"Failed file {update_file.name}: {error_msg}")

        try:
            from datetime import datetime
            import traceback
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            failed_name = f"{timestamp}_{update_file.name}"
            failed_path = self.failed_dir / failed_name

            # Create error info file
            error_file = self.failed_dir / f"{timestamp}_{update_file.stem}_error.txt"
            with open(error_file, "w", encoding="utf-8") as f:
                f.write(f"File: {update_file.name}\n")
                f.write(f"Error: {error_msg}\n")
                f.write(f"Timestamp: {datetime.now().isoformat()}\n")
                f.write(f"Stack trace:\n{traceback.format_exc()}")

            shutil.move(str(update_file), str(failed_path))
            logger.debug(f"❌ Moved to failed: {failed_name}")
        except Exception as e:
            logger.warning(f"Failed to move {update_file.name} to failed: {e}")

    def _log_processing_summary(self) -> None:
        """Log comprehensive processing summary."""
        logger.info("\n📊 Processing Summary:")
        logger.info(f"   Files processed successfully: {self.stats['files_processed']}")
        logger.info(f"   Files with malformed data: {self.stats['files_malformed']}")
        logger.info(f"   Files that failed processing: {self.stats['files_failed']}")
        logger.info(f"   Documentation files updated: {len(self.stats['files_updated'])}")
        logger.info(f"   Changes made to repository: {self.stats['changes_made']}")

        if self.stats["malformed_files"]:
            logger.warning(f"   Malformed files: {', '.join(self.stats['malformed_files'])}")

        if self.stats["failed_files"]:
            logger.warning(f"   Failed files: {', '.join(self.stats['failed_files'])}")

        if self.stats["errors"]:
            logger.warning(f"   Total errors encountered: {len(self.stats['errors'])}")

    def _archive_processed_file(self, update_file: Path) -> None:
        """Move processed file to archive/processed directory."""
        # This method is now replaced by _move_to_processed for better organization
        self._move_to_processed(update_file)

    def _save_stats(self) -> None:
        """Save processing statistics (disabled to prevent merge conflicts)."""
        # Stats file generation disabled to prevent merge conflicts in multi-repo setups
        pass

    def _process_single_file_safely(self, update_file: Path) -> None:
        """Process a single file with comprehensive error handling and immediate archival."""
        logger.debug(f"🔍 Processing: {update_file.name}")

        try:
            # Step 1: Try to parse JSON and validate
            try:
                with open(update_file, encoding="utf-8") as f:
                    update_data = json.load(f)
            except (OSError, json.JSONDecodeError) as e:
                # Don't move files in dry-run mode
                if not self.dry_run:
                    self._move_to_malformed(update_file, f"JSON parse error: {e}")
                else:
                    logger.warning(f"⚠️ [DRY RUN] Would move to malformed: {update_file.name} - JSON parse error: {e}")
                return

            # Step 2: Validate required fields
            required_fields = ["file", "mode", "content"]
            for field in required_fields:
                if field not in update_data:
                    # Don't move files in dry-run mode
                    if not self.dry_run:
                        self._move_to_malformed(update_file, f"Missing required field: {field}")
                    else:
                        logger.warning(f"⚠️ [DRY RUN] Would move to malformed: {update_file.name} - Missing required field: {field}")
                    return

            # Step 3: Process the update
            try:
                self.process_update_file_data(update_file, update_data)
                # Success - move to processed immediately (but not in dry-run mode)
                if self.cleanup and not self.dry_run:
                    self._move_to_processed(update_file)
            except Exception as e:
                if self.continue_on_error:
                    # Don't move files in dry-run mode
                    if not self.dry_run:
                        self._move_to_failed(update_file, str(e))
                else:
                    raise

        except Exception as e:
            error_msg = f"Unexpected error processing {update_file.name}: {str(e)}"
            logger.error(error_msg)
            if self.continue_on_error:
                # Don't move files in dry-run mode
                if not self.dry_run:
                    self._move_to_failed(update_file, error_msg)
                else:
                    logger.warning(f"❌ [DRY RUN] Would move to failed: {update_file.name} - {error_msg}")
            else:
                self.stats["errors"].append(error_msg)
                raise

    def process_update_file_data(self, update_file: Path, update_data: Dict) -> None:
        """Process update data from a successfully parsed file."""
        target_file = Path(update_data["file"])
        mode = update_data["mode"]
        content = update_data["content"]
        options = update_data.get("options", {})

        logger.info(f"📝 Updating {target_file} (mode: {mode})")

        if self.dry_run:
            logger.info(f"🧪 [DRY RUN] Would update {target_file}")
            self.stats["files_processed"] += 1
            return

        # Apply the update
        success = self._apply_update(target_file, mode, content, options)

        if success:
            self.stats["files_processed"] += 1
            self.stats["changes_made"] = True
            if str(target_file) not in self.stats["files_updated"]:
                self.stats["files_updated"].append(str(target_file))
        else:
            raise Exception("Update application failed")

    # ...existing code...
def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description="Process documentation update files",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python doc_update_manager.py
  python doc_update_manager.py --updates-dir .github/doc-updates
  python doc_update_manager.py --dry-run --verbose
  python doc_update_manager.py --no-cleanup
  python doc_update_manager.py --ignore-errors
        """,
    )

    parser.add_argument(
        "--updates-dir",
        default=".github/doc-updates",
        help="Directory containing update files (default: .github/doc-updates)",
    )

    parser.add_argument(
        "--cleanup",
        type=lambda x: x.lower() in ("true", "1", "yes"),
        default=True,
        help="Whether to archive processed files (default: true)",
    )

    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be updated without making changes",
    )

    parser.add_argument("--verbose", action="store_true", help="Enable verbose logging")
    parser.add_argument(
        "--ignore-errors",
        action="store_true",
        help="Continue processing even if some updates fail",
    )

    # Support positional argument for backwards compatibility
    parser.add_argument(
        "updates_directory",
        nargs="?",
        help="Directory with update files (positional, overrides --updates-dir)",
    )

    args = parser.parse_args()

    # Use positional argument if provided
    updates_dir = args.updates_directory or args.updates_dir

    manager = DocumentationUpdateManager(
        updates_dir=updates_dir,
        cleanup=args.cleanup,
        dry_run=args.dry_run,
        verbose=args.verbose,
        continue_on_error=args.ignore_errors,
    )

    try:
        stats = manager.process_all_updates()

        if args.verbose or args.dry_run:
            print("\n📊 Processing Summary:")
            print(f"   Files processed: {stats['files_processed']}")
            print(f"   Files malformed: {stats['files_malformed']}")
            print(f"   Files failed: {stats['files_failed']}")
            print(f"   Changes made: {stats['changes_made']}")
            print(f"   Files updated: {len(stats['files_updated'])}")
            if stats["errors"]:
                print(f"   Errors: {len(stats['errors'])}")
                for error in stats["errors"]:
                    print(f"     - {error}")
            if stats["malformed_files"]:
                print(f"   Malformed files: {', '.join(stats['malformed_files'])}")
            if stats["failed_files"]:
                print(f"   Failed files: {', '.join(stats['failed_files'])}")

        # Exit with error code if there were errors unless ignoring errors
        if stats["errors"] and not args.ignore_errors:
            sys.exit(1)
        if stats["errors"] and args.ignore_errors:
            logger.warning("⚠️ Completed with errors, continuing due to --ignore-errors")

    except KeyboardInterrupt:
        logger.info("🛑 Interrupted by user")
        sys.exit(1)
    except Exception as e:
        logger.error(f"❌ Unexpected error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
