#Simple ruby script to emulate the UNIX which command on Windows

#make default search for exe, option for pathext
#Add help file

filename = ARGV.first
wildcard = ARGV[1]

#Path Stuff
path = `path`

#truncate leading junk
path = path[5...-1]
pathlist = path.split(';')

#nuke trailing slashes
pathlist.collect! { |element|
  element = element.sub(/(\\)+$/,'')
  }

#sanity checks (needs help)
if not ARGV.first
  puts "This script takes a filename as a parameter."
  print "Enter a command to search for: "
  filename = STDIN.gets.chomp()
end

##if filename without .exe is passed, add it
#if !(filename =~ (/.exe/)) and !(wildcard)
#  filename = filename + ".exe"
#end

#if wildcard is passed
if wildcard
  filename = filename + ".*"
  #puts "filename is #{filename}"
end

#pathext
pathext = `set PATHEXT`
pathext = pathext[8...-1]
pathext = pathext.split(';')


#regex for file
reg1 = /#{filename}/i

#pathlist
#puts pathlist

#main loop (comprehensive but slow)
for p in pathlist 
  command = `dir /b "#{p}\\#{filename}" 2>nul`
  if (command =~(reg1))
    puts "#{p}\\#{filename}"
    break
  end
end

def compsearch(pathlist, pathext)
  for p in pathlist
    for e in pathext
      command = `dir /b "#{p}\\#{filename}#{e}" 2>nul`
      if (command =~(reg1))
        puts "#{p}\\#{filename}#{e}"
        break
      end
    end
  end
end




##main loop
#for p in pathlist
#  #puts "p is #{p}"
#  #command = `dir #{p}\\#{filename} 2>nul`
#  command = `dir /b "#{p}\\#{filename}" 2>nul`
#  #print "output for #{p} is #{command}"
#  #STDIN.gets
#  #case insensitive regex for windows
#  #reg1 = /#{filename}/i
#  #puts "reg1 is #{reg1}"
#  if (command =~(reg1))
#    puts "#{p}"
#  end
#end
