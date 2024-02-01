//package kr.co.jhta.restaurants_service.controller;
//
//import com.google.cloud.storage.Blob;
//import com.google.cloud.storage.BlobId;
//import com.google.cloud.storage.BlobInfo;
//import com.google.cloud.storage.Storage;
//import kr.co.jhta.restaurants_service.security.domain.SecurityUser;
//import kr.co.jhta.restaurants_service.service.PostService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.beans.factory.annotation.Value;
//
//import org.springframework.http.HttpHeaders;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.MediaType;
//import org.springframework.http.ResponseEntity;
//import org.springframework.security.core.annotation.AuthenticationPrincipal;
//import org.springframework.stereotype.Controller;
//import org.springframework.web.bind.annotation.*;
//import org.springframework.web.multipart.MultipartFile;
//
//import java.io.IOException;
//
//@Controller
//@RequestMapping("/images")
//public class ImageController {
//
//    @Value("${gcp.bucket.name}")
//    private String bucketName;
//
//    @Autowired
//    Storage storage;
//
//    @Autowired
//    PostService postService;
//
//    public static String[] PUBLIC_URLS = {
//            "/images/user/**",
//            "/images/review/**",
//            "/images/post/**",
//            "/images/logo/**"
//    };
//
//    @ResponseBody
//    @GetMapping("/post/png/{imageName}")
//    public ResponseEntity<byte[]> servePostPngImage(@PathVariable String imageName) throws IOException {
//
//        BlobId blobId = BlobId.of(bucketName,"post/" + imageName);
//
//        Blob blob = storage.get(blobId);
//
//        if (blob != null) {
//            byte[] imageBytes = blob.getContent();
//
//            HttpHeaders headers = new HttpHeaders();
//            headers.setContentType(MediaType.IMAGE_PNG);
//
//            return new ResponseEntity<>(imageBytes, headers, HttpStatus.OK);
//        }
//        else {
//            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
//        }
//    }
//    
//    @ResponseBody
//    @GetMapping("/logo/png/{imageName}")
//    public ResponseEntity<byte[]> serveLogoPngImage(@PathVariable String imageName) throws IOException {
//    	
//    	BlobId blobId = BlobId.of(bucketName,"logo/" + imageName);
//    	
//    	Blob blob = storage.get(blobId);
//    	
//    	if (blob != null) {
//    		byte[] imageBytes = blob.getContent();
//    		
//    		HttpHeaders headers = new HttpHeaders();
//    		headers.setContentType(MediaType.IMAGE_PNG);
//    		
//    		return new ResponseEntity<>(imageBytes, headers, HttpStatus.OK);
//    	}
//    	else {
//    		return new ResponseEntity<>(HttpStatus.NOT_FOUND);
//    	}
//    }
//
//    @ResponseBody
//    @GetMapping("/user/jpeg/{imageName}")
//    public ResponseEntity<byte[]> serveUserJpegImage(@PathVariable String imageName) throws IOException {
//
//        BlobId blobId = BlobId.of(bucketName,"user/" + imageName);
//
//        Blob blob = storage.get(blobId);
//
//        if (blob != null) {
//            byte[] imageBytes = blob.getContent();
//
//            HttpHeaders headers = new HttpHeaders();
//            headers.setContentType(MediaType.IMAGE_PNG);
//
//            return new ResponseEntity<>(imageBytes, headers, HttpStatus.OK);
//        }
//        else {
//            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
//        }
//    }
//
//    @ResponseBody
//    @GetMapping("/post/jpeg/{imageName}")
//    public ResponseEntity<byte[]> servePostJpegImage(@PathVariable String imageName) throws IOException {
//
//        BlobId blobId = BlobId.of(bucketName,"post/" + imageName);
//
//        Blob blob = storage.get(blobId);
//
//        if (blob != null) {
//            byte[] imageBytes = blob.getContent();
//
//            HttpHeaders headers = new HttpHeaders();
//            headers.setContentType(MediaType.IMAGE_JPEG);
//
//            return new ResponseEntity<>(imageBytes, headers, HttpStatus.OK);
//        }
//        else {
//            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
//        }
//    }
//
//    @ResponseBody
//    @GetMapping("/review/png/{imageName}")
//    public ResponseEntity<byte[]> serveReviewPngImage(@PathVariable String imageName) throws IOException {
//
//        BlobId blobId = BlobId.of(bucketName,"review/" + imageName);
//
//        Blob blob = storage.get(blobId);
//
//        if (blob != null) {
//            byte[] imageBytes = blob.getContent();
//
//            HttpHeaders headers = new HttpHeaders();
//            headers.setContentType(MediaType.IMAGE_PNG);
//
//            return new ResponseEntity<>(imageBytes, headers, HttpStatus.OK);
//        }
//        else {
//            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
//        }
//    }
//
//    @ResponseBody
//    @GetMapping("/review/jpeg/{imageName}")
//    public ResponseEntity<byte[]> serveReviewJpegImage(@PathVariable String imageName) throws IOException {
//
//        BlobId blobId = BlobId.of(bucketName,"review/" + imageName);
//
//        Blob blob = storage.get(blobId);
//
//        if (blob != null) {
//            byte[] imageBytes = blob.getContent();
//
//            HttpHeaders headers = new HttpHeaders();
//            headers.setContentType(MediaType.IMAGE_JPEG);
//
//            return new ResponseEntity<>(imageBytes, headers, HttpStatus.OK);
//        }
//        else {
//            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
//        }
//    }
//
//    @ResponseBody
//    @GetMapping("/user/png/{imageName}")
//    public ResponseEntity<byte[]> serveUserPngImage(@PathVariable String imageName) throws IOException {
//
//        BlobId blobId = BlobId.of(bucketName,"user/" + imageName);
//
//        Blob blob = storage.get(blobId);
//
//        if (blob != null) {
//            byte[] imageBytes = blob.getContent();
//
//            HttpHeaders headers = new HttpHeaders();
//            headers.setContentType(MediaType.IMAGE_PNG);
//
//            return new ResponseEntity<>(imageBytes, headers, HttpStatus.OK);
//        }
//        else {
//            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
//        }
//    }
//
//    @ResponseBody
//    @PostMapping("/user-post/png")
//    public ResponseEntity uploadUserPngImage(MultipartFile imageFile, @AuthenticationPrincipal SecurityUser securityUser) {
//
//        try {
//            String objectName = "user/" + securityUser.getUsername();
//
//            BlobId blobId = BlobId.of(bucketName, objectName);
//            BlobInfo blobInfo = BlobInfo.newBuilder(blobId).setContentType(imageFile.getContentType()).build();
//
//            Blob blob = storage.create(blobInfo, imageFile.getBytes());
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//
//        return ResponseEntity.ok().build();
//    }
//
//}
