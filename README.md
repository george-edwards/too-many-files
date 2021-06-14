# too-many-files
Moves files from a single directory into subdirectories, evenly dispersing them by the $RADIX and dynamically naming the subdirectories for appropriate sort-order, i.e., folder-01, or folder-001, or folder-0001, etc.

Written to help Kenrick when a Raspberry Pi saved too many timelapse photos to a single folder on a Windows server. The folder could not be opened by Windows File Explorer or Nautilus in Linux. A simple `ls -l` took tens of minutes.
