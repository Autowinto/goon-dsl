package org.xtext.example.mydsl.generator

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.util.RuntimeIOException
import java.io.InputStream
import java.io.File
import java.nio.file.Files
import java.nio.file.Paths
import java.nio.charset.StandardCharsets

class SimpleFileSystemAccess implements IFileSystemAccess2 {

    override void generateFile(String fileName, CharSequence contents) {
    val outFile = new File(fileName)
    Files.write(Paths.get(outFile.absolutePath), contents.toString.getBytes(StandardCharsets.UTF_8))
    println("Generated file: " + outFile.absolutePath)
}

 
    override void deleteFile(String fileName) {
        // do nothing
    }
				
			override isFile(String path) throws RuntimeIOException {
				throw new UnsupportedOperationException("TODO: auto-generated method stub")
			}
			
			override isFile(String path, String outputConfigurationName) throws RuntimeIOException {
				throw new UnsupportedOperationException("TODO: auto-generated method stub")
			}
			
			override generateFile(String fileName, String outputConfigurationName, CharSequence contents) {
				throw new UnsupportedOperationException("TODO: auto-generated method stub")
			}
			
			override deleteFile(String fileName, String outputConfigurationName) {
				throw new UnsupportedOperationException("TODO: auto-generated method stub")
			}
			
			override getURI(String path) {
				throw new UnsupportedOperationException("TODO: auto-generated method stub")
			}
			
			override getURI(String path, String outputConfiguration) {
				throw new UnsupportedOperationException("TODO: auto-generated method stub")
			}
			
			override generateFile(String fileName, InputStream content) throws RuntimeIOException {
				throw new UnsupportedOperationException("TODO: auto-generated method stub")
			}
			
			override generateFile(String fileName, String outputCfgName, InputStream content) throws RuntimeIOException {
				throw new UnsupportedOperationException("TODO: auto-generated method stub")
			}
			
			override readBinaryFile(String fileName) throws RuntimeIOException {
				throw new UnsupportedOperationException("TODO: auto-generated method stub")
			}
			
			override readBinaryFile(String fileName, String outputCfgName) throws RuntimeIOException {
				throw new UnsupportedOperationException("TODO: auto-generated method stub")
			}
			
			override readTextFile(String fileName) throws RuntimeIOException {
				throw new UnsupportedOperationException("TODO: auto-generated method stub")
			}
			
			override readTextFile(String fileName, String outputCfgName) throws RuntimeIOException {
				throw new UnsupportedOperationException("TODO: auto-generated method stub")
			}
				
}
