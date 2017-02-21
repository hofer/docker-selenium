task :default => [:run]

bin_dir = "./bin_build"
@classes_main = "#{bin_dir}/classes/"
classes_unit = "#{bin_dir}/unittest/"

# ****************************************************************************************************
# Dependencies
# ****************************************************************************************************

desc "Download all libraries needed in this project"
task :lib => [:clean] do
  sh "mkdir -p lib/main lib/test"
  sh "java -jar ivy-2.4.0.jar -ivy ivy.xml -retrieve './lib/[conf]/[artifact](-[classifier])-[revision].[ext]'"
  lib_main = FileList["lib/main/*.jar"]
  lib_main.each do | file_to_delete | 
    sh "rm -rf ./lib/test/#{file_to_delete.split('/').last}"
  end
end

desc "Cleanup lib folder"
task :clean do
  sh "rm -rf lib #{bin_dir}"
end

# ****************************************************************************************************
# Compile
# ****************************************************************************************************

desc "Compile the app"
task :compile => [:clean, :lib] do
  SRC = FileList["src/main/java/**/*.java"]
  mkdir_p @classes_main
  sh "javac -cp './lib/main/*:.' -d '#{@classes_main}' #{SRC.join(" ")}"
end

# ****************************************************************************************************
# Run
# ****************************************************************************************************

def createRunParameters()
  vnc_port="15900"
  pwd=`pwd`.delete("\n").delete("\r")
  puts "*******************************************************************************" 
  puts "* Connect via VNC on localhost:#{vnc_port}"
  puts "*******************************************************************************"
  return "--rm=true -w=#{pwd} -p #{vnc_port}:5900 -v #{pwd}:#{pwd} mhoefi/selenium:1.0 java -cp './lib/main/*:./#{@classes_main}:.' GoogleSuggest"
end

task :run => :compile do
  params = createRunParameters()
  sh "docker run #{params}"
end

task :run_video => :compile do
  params = createRunParameters()
  sh "docker run -e VIDEOON=TRUE #{params}"
end
