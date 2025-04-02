/*
 * generated by Xtext 2.37.0
 */
package org.xtext.example.mydsl.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import org.xtext.example.mydsl.myDsl.Config
import org.xtext.example.mydsl.myDsl.Entry
import org.xtext.example.mydsl.myDsl.Exp
import org.xtext.example.mydsl.myDsl.StringConstraint
import org.xtext.example.mydsl.myDsl.IntConstraint
import org.xtext.example.mydsl.myDsl.BoolConstraint
import org.xtext.example.mydsl.myDsl.IPConstraint
import org.xtext.example.mydsl.myDsl.Requirement
import org.xtext.example.mydsl.myDsl.And


/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class MyDslGenerator extends AbstractGenerator {
	
	
	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		
        var root = resource.allContents.toIterable.filter(Config).get(0)
	    fsa.generateFile("configTests/"+root.name+".java", root.compile())
    }
    
    def compile(Config root)'''
    	import com.fasterxml.jackson.databind.JsonNode;
    	import com.fasterxml.jackson.databind.ObjectMapper;
    	import org.junit.jupiter.api.Test;
    	import static org.junit.jupiter.api.Assertions.*;
    	
    	import java.io.File;
    	import java.io.IOException;
    	
    	public class «root.name»Tests {
    		// Assuming File is named config.json
    		File jsonFile = new File("src/config.json");
    		ObjectMapper objectMapper = new ObjectMapper();
    		JsonNode rootNode;
    		{
    			try {
    				rootNode = objectMapper.readTree(jsonFile);
    			} catch (IOException e) {
    				throw new RuntimeException(e);
    			}
    		}
    		
    		@Test
    		public void testConfigJsonStructure() throws IOException {
    			
    			
    			assertNotNull(rootNode);
    			«FOR entry : root.entries»
    			    assertTrue(rootNode.has("«entry.name»"));
    			    «IF !entry.entries.empty»
    			        JsonNode «entry.name» = rootNode.get("«entry.name»");
    			        «HelperClass.generateAssertions(entry, entry.name)»
    			    «ENDIF»
    			«ENDFOR»
    			
    			
    		}
    		«FOR entry : root.entries»
    			«IF !entry.entries.empty»
    				«HelperClass.generateTests(entry)»
    			«ELSE»	
    			
			@Test
			public void test«entry.name»() throws IOException {
				«HelperClass.compileExp(entry.type, entry)»
			}
    			«ENDIF»
    		«ENDFOR»
    	}
    '''
    
}
    
class HelperClass {
    static def generateAssertions(Entry entry, String parentName) '''
        «FOR subEntry : entry.entries»
            assertTrue(«parentName».has("«subEntry.name»"));
            «IF !subEntry.entries.empty»
                JsonNode «subEntry.name» = «parentName».get("«subEntry.name»");
                «generateAssertions(subEntry, subEntry.name)»
            «ENDIF»
        «ENDFOR»
    '''
    static def generateTests(Entry entry) '''
        «FOR subEntry : entry.entries»
        	«IF !subEntry.entries.empty»«generateTests(subEntry)»
        	«ELSE»
        		
        	@Test
        	public void test«subEntry.name»() throws IOException {
        		«subEntry.type.compileExp(subEntry)»
        	}
        	«ENDIF»
        «ENDFOR»
    '''
   
	
	static def String compileExp(Exp exp, Entry entry) {
   	
		if (exp instanceof And) {
    		return exp.left.compileExp(entry) + "\n" + exp.right.compileExp(entry);
		} else if (exp instanceof StringConstraint) {
			if(exp.constraint.equals('=')){
				return "assertEquals(\"\\\""+exp.value+"\\\"\",rootNode.findPath("+"\""+entry.name+"\""+").toString());";
			} else if(exp.constraint.equals('!=')){
				return "assertNotEquals(\"\\\""+exp.value+"\\\"\",rootNode.findPath("+"\""+entry.name+"\""+").toString());";
			}
		} else if (exp instanceof IntConstraint) {
			return "assertTrue(Integer.parseInt(rootNode.findPath("+"\""+entry.name+"\""+").toString())"+ exp.constraint +exp.value +");";
			
		} else if (exp instanceof Requirement) {
			return "assertTrue(!rootNode.findPath(\""+ exp.ref.name + "\").toString().isEmpty());";
		} else if (exp instanceof BoolConstraint) {
			if(exp.constraint.equals('=')){
				return "assertEquals(\"\\\""+exp.value+"\\\"\",rootNode.findPath("+"\""+entry.name+"\""+").toString());";
			} else if(exp.constraint.equals('!=')){
				return "assertNotEquals("+exp.value+",rootNode.findPath("+"\""+entry.name+"\""+").toString());";
			}
		} else if (exp instanceof IPConstraint) {
			if(exp.constraint.equals('=')){
				return "assertEquals(\"\\\""+exp.value+"\\\"\",rootNode.findPath("+"\""+entry.name+"\""+").toString());";
			}
		}
	}  
}


    
   
