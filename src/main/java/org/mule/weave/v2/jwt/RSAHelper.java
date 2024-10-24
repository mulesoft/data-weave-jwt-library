package org.mule.weave.v2.jwt;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigInteger;
import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.security.*;
import java.security.cert.CertificateException;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.RSAPrivateCrtKeySpec;
import java.util.Base64;

public class RSAHelper {

    private static final String BEGIN_RSA_PRIVATE_KEY = "BEGIN RSA PRIVATE KEY";
    private static final String BEGIN_RSA_KEY = "-----" + BEGIN_RSA_PRIVATE_KEY + "-----";
    private static final String END_RSA_KEY = "-----END RSA PRIVATE KEY-----";

    private static final String BEGIN_PRIVATE_KEY = "-----BEGIN PRIVATE KEY-----";
    private static final String END_PRIVATE_KEY = "-----END PRIVATE KEY-----";

    public static String signString(String content, String privateKeyContent, String algorithm) throws NoSuchAlgorithmException, InvalidKeySpecException, InvalidKeyException, IOException, SignatureException {
        PrivateKey pk;
        if (privateKeyContent.contains(BEGIN_RSA_PRIVATE_KEY))
            pk = getPrivatePKCS1Pem(privateKeyContent);
        else
            pk = getPrivatePKCS8Pem(privateKeyContent);

        Signature privateSignature = Signature.getInstance(algorithm);
        privateSignature.initSign(pk);
        privateSignature.update(content.getBytes(StandardCharsets.UTF_8));
        byte[] s = privateSignature.sign();
        return Base64.getUrlEncoder().encodeToString(s).replace("=", "");
    }

    public static String signStringWithKeyStore(String content, String keystorePath, String keystoreType, String keystorePassword, String keyAlias, String algorithm) throws NoSuchAlgorithmException, IOException, KeyStoreException, CertificateException, UnrecoverableKeyException, InvalidKeyException, SignatureException {
        PrivateKey pk = getPrivatePKCS8Pem(keystorePath, keystoreType, keystorePassword, keyAlias);
        Signature privateSignature = Signature.getInstance(algorithm);
        privateSignature.initSign(pk);
        privateSignature.update(content.getBytes(StandardCharsets.UTF_8));
        byte[] s = privateSignature.sign();
        return Base64.getUrlEncoder().encodeToString(s).replace("=", "");
    }

    private static PrivateKey getPrivatePKCS1Pem(String privateKeyContent) throws NoSuchAlgorithmException, InvalidKeySpecException {
        privateKeyContent = privateKeyContent.replaceAll("\\n", "").replace(BEGIN_RSA_KEY, "")
                .replace(END_RSA_KEY, "");
        byte[] bytes = Base64.getDecoder().decode(privateKeyContent);

        RSAPrivateCrtKeySpec keySpec = decodeRSAPrivatePKCS1(bytes);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        return keyFactory.generatePrivate(keySpec);
    }

    private static PrivateKey getPrivatePKCS8Pem(String keystorePath, String keystoreType, String keystorePassword, String keyAlias) throws NoSuchAlgorithmException, KeyStoreException, IOException, CertificateException, UnrecoverableKeyException {
        KeyStore keystore = KeyStore.getInstance(keystoreType);

        InputStream is = RSAHelper.class.getClassLoader().getResourceAsStream(keystorePath);

        keystore.load(is, keystorePassword.toCharArray());

        // Get the private key entry
        if (!keystore.containsAlias(keyAlias)) {
            throw new IllegalArgumentException("Alias not found: " + keyAlias);
        }

        // Get the private key - for PKCS12, the key password is the same as the keystore password

        // Convert to PKCS8 format and encode as Base64

        return (PrivateKey) keystore.getKey(
                keyAlias,
                keystorePassword.toCharArray()
        );
    }

    private static PrivateKey getPrivatePKCS8Pem(String privateKeyContent) throws InvalidKeySpecException, NoSuchAlgorithmException {
        privateKeyContent = privateKeyContent.replaceAll("\\n", "").replace(BEGIN_PRIVATE_KEY, "")
                .replace(END_PRIVATE_KEY, "");
        byte[] bytes = Base64.getDecoder().decode(privateKeyContent);

        PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(bytes);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        return keyFactory.generatePrivate(keySpec);
    }

    private static RSAPrivateCrtKeySpec decodeRSAPrivatePKCS1(byte[] encoded) {
        ByteBuffer input = ByteBuffer.wrap(encoded);
        if (der(input, 0x30) != input.remaining()) throw new IllegalArgumentException("Excess data");
        if (!BigInteger.ZERO.equals(derint(input))) throw new IllegalArgumentException("Unsupported version");
        BigInteger n = derint(input);
        BigInteger e = derint(input);
        BigInteger d = derint(input);
        BigInteger p = derint(input);
        BigInteger q = derint(input);
        BigInteger ep = derint(input);
        BigInteger eq = derint(input);
        BigInteger c = derint(input);
        return new RSAPrivateCrtKeySpec(n, e, d, p, q, ep, eq, c);
    }

    private static int der(ByteBuffer input, int exp) {
        int tag = input.get() & 0xFF;
        if (tag != exp) throw new IllegalArgumentException("Unexpected tag");
        int n = input.get() & 0xFF;
        if (n < 128) return n;
        n &= 0x7F;
        if ((n < 1) || (n > 2)) throw new IllegalArgumentException("Invalid length");
        int len = 0;
        while (n-- > 0) {
            len <<= 8;
            len |= input.get() & 0xFF;
        }
        return len;
    }

    private static BigInteger derint(ByteBuffer input) {
        int len = der(input, 0x02);
        byte[] value = new byte[len];
        input.get(value);
        return new BigInteger(+1, value);
    }
}
