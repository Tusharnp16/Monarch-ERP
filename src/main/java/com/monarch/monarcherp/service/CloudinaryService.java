package com.monarch.monarcherp.service;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.MessageDigest;
import java.util.HexFormat;
import java.util.Map;

@Service
public class CloudinaryService {

    @Autowired
    private Cloudinary cloudinary;

    public String uploadFile(MultipartFile file) {
//        try {
//            Map uploadResult = cloudinary.uploader().upload(file.getBytes(), ObjectUtils.emptyMap());
//            return uploadResult.get("secure_url").toString();
//        } catch (IOException e) {
//            throw new RuntimeException("Cloudinary upload failed", e);
//        }

        try {
            byte[] fileBytes = file.getBytes();
            String fileHash = calculateHash(fileBytes);

            Map params = ObjectUtils.asMap(
                    "public_id", fileHash,
                    "overwrite", false,
                    "folder", "monarch_erp/variants"
            );

            Map uploadResult = cloudinary.uploader().upload(fileBytes, params);
            return uploadResult.get("secure_url").toString();
        } catch (Exception e) {
            throw new RuntimeException("Upload failed", e);
        }
    }

    private String calculateHash(byte[] data) throws Exception {
        byte[] hash = MessageDigest.getInstance("SHA-256").digest(data);
        return HexFormat.of().formatHex(hash);
    }


}
