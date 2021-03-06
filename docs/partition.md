# Introduction
This document defines the format of the gecko partitioning system. This document only describes version 1.0. All values are in little endian.

# Boot sector
Table 1
| Offset | Length | Definition                         |
| :----: | :----: | :--------:                         |
| 0      | 500    | Boot code (Must not be used for file systems or similar. This is supposed to be the boot code, not an area for data that isn't directly needed by the bootloader.) |
| 500    | 8      | LBA of partition table             |
| 508    | 2      | Size of partition table in sectors |
| 510    | 2      | Boot signature                     |

# Partition table
The partition table stores every partition on the disk. The last partition must be immediately before a partition that has the end marker flag set. Only one partition can have the end marker set. All partitions after the end marker must have all data zeroed.

Table 2
| Offset | Length | Definition                        |
| :----: | :----: | :--------:                        |
| 0      | 8      | First sector in LBA               |
| 8      | 8      | Last sector in LBA                |
| 16     | 4      | File system name in ASCII (either 4 characters or has terminating null) |
| 20     | 2      | File system version major         |
| 22     | 2      | File system version minor         |
| 24     | 2      | Flags (See table 3)               |
| 26     | 1      | Partition table version major (1) |
| 27     | 1      | Partition table version minor (0) |
| 28     | 4      | Unused, should be zero            |

Table 3
| Mask   | Definition                                            |
| :--:   | :--------:                                            |
| 0x0001 | Bootable                                              |
| 0x0002 | Important                                             |
| 0x0004 | End marker                                            |
| 0x0008 | Usable                                                |
| 0x0010 | Automatically mounted. May be interpreted in any way* |

<br><br><br><br>

*This should mean that the drive's filesystem is assigned a path from the root directory. For non-filesystem partitions the path may be a file containing the raw bytes of the partition. If there is no filesystem, then this appendix is irrelevant