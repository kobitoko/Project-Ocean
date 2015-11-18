package jasyptexperiment;

// using jasypt http://www.jasypt.org/
import org.jasypt.digest.StandardStringDigester;
import java.util.Scanner;

public class JasyptExperiment {
    
    public StandardStringDigester s;

    public static void main(String[] args) {
        
        JasyptExperiment je = new JasyptExperiment();
        
        je.init();
        
        Scanner in = new Scanner(System.in);
        
        System.out.println("Enter the text to get the hash and salt from it:");
        
        String plain = in.nextLine();
        
        // encrypt the plain string.
        String digestMessage = je.s.digest(plain);
        
        String full = digestMessage;
        // substring's index begin is inclusive, and index end is exclusive.
        // salt is prepended.
        String hash = full.substring(32,64);
        String salt =full.substring(0, 32);
        
        System.out.println("The text is:" + plain);
        System.out.println("The hash for that text is:" + hash);
        System.out.println("The salt for that text is:" + salt);
    }

    public void init() {
            s = new StandardStringDigester();
            
            s.setAlgorithm("MD5");
            
            s.setIterations(999);
            
            // For the delicious salt: by default an instance of RandomSaltGenerator will be used.
            s.setSaltSizeBytes(16);
            
            // default is base64
            s.setStringOutputType("hexadecimal");
            
            s.initialize();
    }
    
}
