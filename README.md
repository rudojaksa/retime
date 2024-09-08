# Fix the mtime of directory

Retime &ndash; interactive utility to set the modification time of the
directory to that of the last modified file inside this directory:

 1. look for the last modified file in the directory, recursively check subdirs,
 2. display the summary,
 3. ask for permission to modify the mtime of the directory,
 4. modify it.

```
rj@ws:~/prj#
rj@ws:~/prj# retime retime/
2024-09-07 21:52:46 retime/TODO
2024-09-07 21:54:11 retime/.gitignore
                    ...
2024-09-07 14:53:30 retime/retime
2024-09-07 14:53:30 retime/mtime.md
2024-09-07 14:53:30 retime/retime.md
2024-09-07 14:58:49 retime/README.md
--------------------------------------
2024-09-08 15:01:09 retime/ directory
2024-09-07 14:58:49 last mtime <- Retime to this? (Y/n) y
2024-09-07 14:58:49 retime/
rj@ws:~/prj#
```

### Utils

&nbsp;&nbsp; [retime -h](retime.md) : set the mtime of the directory to that of its content  
&nbsp;&nbsp; [mtime -h](mtime.md) : list files according to their modification time  

### Installation

Just copy the shell scripts `retime` and/or `mtime` to `/usr/local/bin` or `~/bin`,
or use `make install` to do it.

---

##### method: find files and sort them according to their modification time

This method calls `stat` from inside `find` using `find`'s `+` arguments
grouping:

```
find -type f -exec stat -c "%y %n" {} + 2>/dev/null | sort | sed 's:\.[0-9][0-9]* +[0-9]* \(\./\)\?: :' 
```

Slower method using `find`'s builtin printf:

```
find -type f -printf '%TF %TH:%TM:%TS %p\n' 2>/dev/null | sort | sed 's:\.[0-9][0-9]* \(\./\)\?: :'
```

<br><div align=right><i>R.Jaksa 2024</i></div>
