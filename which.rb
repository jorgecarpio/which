#Simple ruby script to emulate the UNIX which command on Windows

filename = ARGV.first
#wildcard = ARGV[1]

#Path Stuff
path = `path`

#truncate leading junk
path = path[5...-1]
pathlist = path.split(';')

#nuke trailing slashes
pathlist.collect! { |element|
  element = element.sub(/(\\)+$/,'')
  }

#produce help
if not ARGV.first
  puts <<HELP_DOC
NAME
which - shows the full path of commands

OPTIONS
first parameter: command to search without extension (i.e. "which ruby")
- .exe suffix is automatically added if omitted

second parameter (optional): -deep (i.e. "which irb -deep")
- used if extension unknown and not found using regular search
- will cycle through all executable command using PATHEXT variable.
- no need to add (or guess) extension for commands to search for

NOTES
if command is in multiple locations all will be returned

HELP_DOC
  exit
end

#pathext
pathext = `set PATHEXT`
pathext = pathext[8...-1]
pathext = pathext.split(';')

#regex for file
reg1 = /#{filename}/i

def mainloop(pathlist, filename, reg1)
  for p in pathlist 
    command = `dir /b "#{p}\\#{filename}" 2>nul`
    if (command =~(reg1))
      puts "#{p}\\#{filename}"
      break
    end
  end  
end

def compsearch(pathlist, pathext, filename, reg1)
  for p in pathlist
    for e in pathext
      command = `dir /b "#{p}\\#{filename}#{e}" 2>nul`
      if (command =~(reg1))
        puts "#{p}\\#{filename}#{e}"
      end
    end
  end
end

if not ARGV.last == "-deep"
  if !(filename =~ (/.exe/))
    filename = filename + ".exe"
  end
  mainloop(pathlist, filename, reg1)
else
  puts "performing deep search, please wait..."
  compsearch(pathlist, pathext, filename, reg1)
end