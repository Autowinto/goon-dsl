package org.xtext.example.mydsl;

import java.io.File;
import java.io.IOException;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.xtext.generator.IFileSystemAccess2;
import org.xtext.example.mydsl.generator.MyDslGenerator;
import org.xtext.example.mydsl.generator.SimpleFileSystemAccess;

import com.google.inject.Injector;

public class Main {
    public static void main(String[] args) {
        if (args.length == 0) {
            System.err.println("Usage: java -jar your.jar path/to/file.goon");
            System.exit(1);
        }

        String dslFilePath = args[0];
        File dslFile = new File(dslFilePath);
        if (!dslFile.exists()) {
            System.err.println("File not found: " + dslFilePath);
            System.exit(1);
        }

        try {
            // 1. Initialize Xtext Standalone setup
            MyDslStandaloneSetup.doSetup();
            MyDslStandaloneSetupGenerated setup = new MyDslStandaloneSetupGenerated();
            Injector injector = setup.createInjectorAndDoEMFRegistration();
            // 2. Create injector and get ResourceSet
            ResourceSet resourceSet = injector.getInstance(ResourceSet.class);

            // 3. Load the DSL resource using the registered resource factory
            Resource resource = resourceSet.getResource(URI.createFileURI(dslFile.getAbsolutePath()), true);
            resource.load(null);  // load with no options

            // 4. Call your generator (passing implementation IFileSystemAccess2 interface and IGeneratorContex)
            MyDslGenerator generator = injector.getInstance(MyDslGenerator.class);
            generator.doGenerate(resource, new SimpleFileSystemAccess(), null);

            System.out.println("DSL file processed successfully.");

        } catch (IOException e) {
            e.printStackTrace();
            System.exit(1);
        }
    }
}
