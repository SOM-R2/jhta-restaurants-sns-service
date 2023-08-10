package kr.co.jhta.restaurants_service.service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;

import kr.co.jhta.restaurants_service.controller.command.PostDataCommand;
import org.jboss.logging.Logger;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import kr.co.jhta.restaurants_service.mapper.PostMapper;
import kr.co.jhta.restaurants_service.mapper.StoreMapper;
import kr.co.jhta.restaurants_service.mapper.PostDataMapper;
import kr.co.jhta.restaurants_service.vo.post.Post;
import kr.co.jhta.restaurants_service.vo.post.PostData;
import kr.co.jhta.restaurants_service.vo.store.Store;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PostService {

	private final Logger logger = Logger.getLogger(PostService.class);

	private final PostMapper postmapper;

	private final StoreMapper storeMapper;

	private final PostDataMapper postDataMapper;


	public List<Post> getAllPosts(){
		List<Post> posts = postmapper.getAllPosts();
		return posts;
	}

//	public void insertPost(String title, String content, String pictureName) {
//		Post post = new Post();
//		post.setTitle(title);
//		post.setContent(content);
//		
//		postmapper.insertPost(post);
//		
//		PostPicture postPicture = new PostPicture();
//		postPicture.setPictureName(pictureName);
//		postPicture.setPost(post);
//		
//		postPictureMapper.insertPostPicture(postPicture);
//	}

//	public void insertPosts(PostData postData) {
//	    List<Post> posts = new ArrayList<>();
//	    List<PostPicture> postPictures = new ArrayList<>();
//	    
//	    for (int i=0; i < posts.size() ; i++) {
//	        Post post = new Post();
//	        post.setStore(posts.get(i).getStore());
//	        post.setContent(posts.get(i).getContent());
//	        posts.add(post);
//
//	        PostPicture postPicture = new PostPicture();
//	        postPicture.setPictureName(posts.get(i).getPictureName());
//	        postPicture.setPost(post);
//	        postPictures.add(postPicture);
//	    }
//	    
//	    postmapper.insertPost(posts);
//	    postPictureMapper.insertPostPicture(postPictures);
//	}


	public void insertPost(Post post, List<PostDataCommand> postDataCommands) throws IOException {


		postmapper.insertPost(post);

		postDataCommands.stream()
				.map(postDataCommand -> {
					Store store = storeMapper.getStoreById(postDataCommand.getStoreId());
					return new PostData(post, store, postDataCommand.getContent(), postDataCommand.getChooseFile().getOriginalFilename());
				})
				.forEach(postData -> {
					postDataMapper.insertPostData(postData);
				});
    }

	public void updatePost(String title, String content, String pictureName) {

	}

	private String saveFile(MultipartFile multipartFile) throws IOException {
		String filename = null;
		String projectHome = System.getenv("PROJECT_HOME");
		String directory = projectHome + "/src/main/webapp/resources/image";
//		String directory = "C:\\Users\\GOTAEHWA\\Desktop\\중앙HTA\\파이널\\picture";
//		if (!multipartFile.isEmpty()) {
//			filename = multipartFile.getOriginalFilename();
//			FileOutputStream out = new FileOutputStream(new File(directory, filename));
//			FileCopyUtils.copy(multipartFile.getInputStream(), out);
//			
//		}

		if (!multipartFile.isEmpty()) {
			try {
				filename = multipartFile.getOriginalFilename();
				FileOutputStream out = new FileOutputStream(new File(directory, filename));
				FileCopyUtils.copy(multipartFile.getInputStream(), out);
				out.close();
			} catch (IOException e) {
				// 파일 생성 또는 복사 작업에서 예외 처리
				throw new IOException("Failed to save file: " + filename, e);
			}
		}

		return filename;
	}

}
