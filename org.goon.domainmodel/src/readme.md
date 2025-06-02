Guide:
run the generated jar file (exported from Eclipse) on a .goon configuration like "java -jar goon.jar ./goon.goon"
this generates a src folder with a test file, and a pom.xml. in this directory, run "mvn clean test Dpath=path_to_file_for_testing"
this generates the mvn resources and runs the generated tests.