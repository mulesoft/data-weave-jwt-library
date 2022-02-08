import sun.security.util.DerInputStream;
import sun.security.util.DerValue;

import java.io.IOException;
import java.math.BigInteger;
import java.security.*;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.RSAPrivateCrtKeySpec;
import java.util.Base64;

public class RSAHelper {
    public static String signString(String content, String privateKeyContent, String algorithm) throws NoSuchAlgorithmException, InvalidKeySpecException, InvalidKeyException, IOException, SignatureException {
        PrivateKey pk = null;
        if (privateKeyContent.contains("RSA"))
            pk = getPrivatePKCS1Pem(privateKeyContent);
        else
            pk = getPrivatePKCS8Pem(privateKeyContent);

        Signature privateSignature = Signature.getInstance(algorithm);
        privateSignature.initSign(pk);
        privateSignature.update(content.getBytes("UTF-8"));
        byte[] s = privateSignature.sign();
        return Base64.getUrlEncoder().encodeToString(s).replace("=", "");
    }

    private static PrivateKey getPrivatePKCS1Pem(String privateKeyContent) throws IOException, NoSuchAlgorithmException, InvalidKeySpecException {
        privateKeyContent = privateKeyContent.replaceAll("\\n", "").replace("-----BEGIN RSA PRIVATE KEY-----", "")
                .replace("-----END RSA PRIVATE KEY-----", "");
        byte[] bytes = Base64.getDecoder().decode(privateKeyContent);

        DerInputStream derReader = new DerInputStream(bytes);
        DerValue[] seq = derReader.getSequence(0);
        // skip version seq[0];
        BigInteger modulus = seq[1].getBigInteger();
        BigInteger publicExp = seq[2].getBigInteger();
        BigInteger privateExp = seq[3].getBigInteger();
        BigInteger prime1 = seq[4].getBigInteger();
        BigInteger prime2 = seq[5].getBigInteger();
        BigInteger exp1 = seq[6].getBigInteger();
        BigInteger exp2 = seq[7].getBigInteger();
        BigInteger crtCoef = seq[8].getBigInteger();

        RSAPrivateCrtKeySpec keySpec =
                new RSAPrivateCrtKeySpec(modulus, publicExp, privateExp, prime1, prime2, exp1, exp2, crtCoef);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PrivateKey privateKey = keyFactory.generatePrivate(keySpec);
        return privateKey;
    }

    private static PrivateKey getPrivatePKCS8Pem(String privateKeyContent) throws InvalidKeySpecException, NoSuchAlgorithmException {
        privateKeyContent = privateKeyContent.replaceAll("\\n", "").replace("-----BEGIN PRIVATE KEY-----", "")
                .replace("-----END PRIVATE KEY-----", "");
        byte[] bytes = Base64.getDecoder().decode(privateKeyContent);

        PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(bytes);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PrivateKey privateKey = keyFactory.generatePrivate(keySpec);
        return privateKey;
    }
}
