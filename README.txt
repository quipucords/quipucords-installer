
Add bin/ directory to the PATH:

  export PATH=":`pwd`/bin:${PATH}"


To Investigate:
- Running discovery-db as User, files are somehow created as 100025 and not 1001.

