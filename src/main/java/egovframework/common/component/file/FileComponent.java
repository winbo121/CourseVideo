package egovframework.common.component.file;


import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.nio.file.attribute.PosixFilePermission;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.function.BiFunction;
import java.util.function.Function;
import java.util.stream.Collectors;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.SystemUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.google.common.base.Preconditions;

import egovframework.common.component.file.attribute.ReAlignFileList;
import egovframework.common.component.file.mapper.FileMapper;
import egovframework.common.component.file.model.FileData;
import egovframework.common.constrant.EnumCodes.FILE_DOWN_TYPE;
import egovframework.common.constrant.EnumCodes.FILE_REG_GB;
import egovframework.common.constrant.EnumCodes.RESOURCE_DOWNLOAD;
import egovframework.common.error.exception.ErrorMessageException;
import egovframework.common.util.CommonUtils;
import egovframework.common.util.StreamUtils;
import egovframework.config.util.ConfigUtils;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class FileComponent {

	/** UPLOAD , DOWNLOAD FIE 경로 **/
    private final Path upload_file_location;

    /** IMAGE UPLOAD FILE 경로 **/
    private final Path image_file_location;

    @Autowired
    private FileMapper fileMapper;
    
    


	public FileComponent( @Value(value="${file.upload.dir}") final String file_upload_dir
								,@Value(value="${image.upload.dir}") final String image_upload_dir ) {

		/**  업로드 파일 경로  **/
    	this.upload_file_location = Paths.get( file_upload_dir ).toAbsolutePath().normalize();
        try {
        	Files.createDirectories( this.upload_file_location );

        	log.info(" ########################################");
        	log.info(" # [FILE UPLOAD CREATE DIRECTORY SUCCESS]" );
        	log.info(" # UPLOAD FILE LOCATION: {}",  this.upload_file_location );
        	log.info(" ########################################");
        }catch(Exception e) {
        	log.error(" ########################################");
        	log.error(" # [FILE UPLOAD CREATE DIRECTORY FAIL]" );
        	log.error(" # EXCEPTION: {}",  e );
        	log.error(" ########################################");
        	/** 파일을 업로드할 디렉토리를 생성하지 못했습니다.  **/
        	throw new ErrorMessageException("file.dir.fail");
        }

        this.image_file_location = Paths.get( image_upload_dir ).toAbsolutePath().normalize();
        try {

        	Files.createDirectories( this.image_file_location );

        	log.info(" ########################################");
        	log.info(" # [IMAGE UPLOAD CREATE DIRECTORY SUCCESS]" );
        	log.info(" # IMAGE UPLOAD LOCATION: {}",  this.image_file_location );
        	log.info(" ########################################");
        }catch(Exception e) {
        	log.error(" ########################################");
        	log.error(" # [IMAGE UPLOAD CREATE DIRECTORY FAIL]" );
        	log.error(" # EXCEPTION: {}",  e );
        	log.error(" ########################################");
        	/** 파일을 업로드할 디렉토리를 생성하지 못했습니다.  **/
        	throw new ErrorMessageException("file.dir.fail");
        }

	}

	/** 이미지 서버 ROOT 경로 **/
	@Value(value="${img.server.root.path}")
	private String img_server_root_path;

	/** 이미지 서버 사용 하는 파일 유형일경우 IMAGE SERVER URL 를 세팅한다.  **/
	private final Function< FILE_REG_GB, Function<FileData, FileData > > INJECT_IMG_URL = file_reg_gb -> {
		if(  file_reg_gb.isUse_image_server() ) {
			return file -> file.injectImgUrl( this.img_server_root_path );
		}else {
			return file -> file.injectfileUrl( this.file_server_root_path );
		}
	};
	
	/** 파일 서버 ROOT 경로 **/
	@Value(value="${file.server.root.path}")
	private String file_server_root_path;

	/** 파일 서버 사용 하는 파일 유형일경우 FILE SERVER URL 를 세팅한다.  **/
//	private final Function< FILE_REG_GB, Function<FileData, FileData > > INJECT_FILE_URL = file_reg_gb -> {
//		if(  file_reg_gb.isUse_file_server() ) {
//			return file -> file.injectfileUrl( this.file_server_root_path );
//		}else {
//			return Function.identity();
//		}
//	};


	/** 파일의 리스트를 조회한다.  **/
	public List<FileData> getFiles( FILE_REG_GB file_reg_gb, String tar_info_pk  ){
		Preconditions.checkNotNull( file_reg_gb, "file_reg_type IS NULL..." );
		Preconditions.checkNotNull( tar_info_pk, "re_align_file_list IS NULL..." );
		List<FileData> file_list = fileMapper.getFiles(file_reg_gb.code() , tar_info_pk, null );

		return StreamUtils.toStream( file_list )
					 .map( INJECT_IMG_URL.apply(file_reg_gb) )
					 .collect( Collectors.toList() );
	}

	/** 파일 상세 조회 **/
	public Optional<FileData> getFile( Integer file_seq ){
		List<FileData> file_list =  fileMapper.getFiles( null, null, file_seq );
    	return StreamUtils.toStream( file_list )
							  .findFirst();
	}


	/** 파일을 삭제한다. ( 전체 ) **/
	public Integer removeFile( FILE_REG_GB file_reg_gb, String tar_info_pk  ) {
		return this.removeFile(file_reg_gb, tar_info_pk, null );
	}
	/** 파일을 삭제한다. ( 전체 ) **/
	public Integer removeFiless( FILE_REG_GB file_reg_gb, List<String> tar_info_pk  ) {
		return this.removeFiles(file_reg_gb, tar_info_pk, null );
	}
	private Integer removeFiles(FILE_REG_GB file_reg_gb, List<String> tar_info_pk, List<Integer> file_seq_list) {
		Preconditions.checkNotNull( file_reg_gb, "file_reg_type IS NULL..." );
		Preconditions.checkNotNull( tar_info_pk, "re_align_file_list IS NULL..." );

		return fileMapper.removeFiles(file_reg_gb.code(), tar_info_pk, file_seq_list );
	}

	/** 파일을 삭제한다. ( 선택된 file seq 만 ) **/
	public Integer removeFile( FILE_REG_GB file_reg_gb, String tar_info_pk ,List<Integer> file_seq_list ) {
		Preconditions.checkNotNull( file_reg_gb, "file_reg_type IS NULL..." );
		Preconditions.checkNotNull( tar_info_pk, "re_align_file_list IS NULL..." );

		return fileMapper.removeFile(file_reg_gb.code(), tar_info_pk, file_seq_list );
	}


	private static final Function< FILE_REG_GB, String > FUNCTION_FILE_SAVE_ROOT =
			( file_reg_gb ) -> {
				 return new StringBuilder()
					        .append( file_reg_gb.code() )
					        .append( File.separator )
					        .toString();
			};
	/** 파일 저장 경로 생성 함수 **/
	private static final BiFunction< LocalDateTime ,FILE_REG_GB ,String > FUNCTION_FILE_SAVE_PATH =
			( now, file_reg_gb ) -> {
				 String yyyyMMdd =  now.format(  DateTimeFormatter.ofPattern( "yyyyMMdd" ) );
				 return new StringBuilder()
						        .append( file_reg_gb.code() )
						        .append( File.separator )
						        .append( yyyyMMdd )
						        .append( File.separator )
						        .toString();
			};


	/** 파일 저장 이름 생성 함수 **/
	private static final BiFunction< LocalDateTime, String, String > FUNCTION_FILE_SAVE_NAME =
			( now, user_id ) -> {
				String hhmmssSSS =  now.format( DateTimeFormatter.ofPattern( "HHmmssSSS" ) );
				return new StringBuilder()
						  	.append( hhmmssSSS)
					        .append( "_" )
					        .append( UUID.randomUUID().toString() )
					        .toString();
			};
			
			
	/** 777 권한 **/
	private static final Set<PosixFilePermission> FULL_PERMISSION = 	 EnumSet.allOf( PosixFilePermission.class );


	/** 한건의 파일 등록을 수행한다. **/
	private Integer saveFileOnce( FILE_REG_GB file_reg_gb, String tar_info_pk, MultipartFile file ) {
		Preconditions.checkNotNull( file_reg_gb, "file_reg_type IS NULL..." );
		Preconditions.checkNotNull( tar_info_pk, "re_align_file_list IS NULL..." );
		/** 멀티파트 파일이 존재하지 않는경우  **/
		if( file == null || file.isEmpty() ) {
			return null;
		}
		
		
        /** 현재시간  **/
        LocalDateTime now = LocalDateTime.now();
        /** 파일 ROOT 경로 **/
        String file_root_path = FUNCTION_FILE_SAVE_ROOT.apply( file_reg_gb );
		/** 파일 저장 경로 **/
		String file_save_path = FUNCTION_FILE_SAVE_PATH.apply( now , file_reg_gb );
		/** 저장 파일 명  **/
		String save_filenm = FUNCTION_FILE_SAVE_NAME.apply( now,  null );
		/** 파일 원본 명  **/
		String original_name = file.getOriginalFilename();
		/** 파일 확장자 **/
		String file_ext = com.google.common.io.Files.getFileExtension( original_name  );
		/** 파일 확장자 제거 원본 명 **/
		String orgin_filenm =  com.google.common.io.Files.getNameWithoutExtension( original_name );
		
		

		try {
			Path root_path = null;
			Path dir_path = null;
			Path file_path = null;
			
			if ( file_reg_gb.isUse_image_server() ) {
				/** 이미지 서버 파일 업로드 대상 **/
				root_path = this.image_file_location.resolve( file_root_path );
				dir_path = this.image_file_location.resolve( file_save_path );
				file_path = dir_path.resolve(  save_filenm  );
				
			} else {
				/** 일반 파일 업로드 대상 **/
				root_path = this.upload_file_location.resolve( file_root_path );
				dir_path = this.upload_file_location.resolve( file_save_path );
				
				if(file_ext.equals("mp4")) {
					String save_filenm_ext = save_filenm+ "." +file_ext;
					file_path = dir_path.resolve(  save_filenm_ext  );
				} else {
					file_path = dir_path.resolve(  save_filenm  );
				}

			}

				
			/** 디렉토리 생성 **/
			Files.createDirectories( dir_path );

			if( SystemUtils.IS_OS_LINUX ) {
				/** OS 가 리눅스인경우 디렉토리에 대해서 777 권한 세팅 **/
				Files.setPosixFilePermissions( root_path, FULL_PERMISSION );
				Files.setPosixFilePermissions( dir_path, FULL_PERMISSION );
			}
			
			/** 파일 이동  **/
			Files.copy( file.getInputStream(), file_path, StandardCopyOption.REPLACE_EXISTING );

			if( SystemUtils.IS_OS_LINUX ) {
				/**  OS 가 리눅스인경우 파일에 대해서 777 권한 세팅 **/
				Files.setPosixFilePermissions( file_path, FULL_PERMISSION );
			}
			  
			/** 이미지 파일이 아닐 시 **/
			if((file.getOriginalFilename().contains("pptx") || file.getOriginalFilename().contains("ppt")) 
				   || (file.getOriginalFilename().contains("tiff")||file.getOriginalFilename().contains("tif"))
				   || (file.getOriginalFilename().contains("pdf")||file.getOriginalFilename().contains("hwp"))
				   || (file.getOriginalFilename().contains("mp4")||file.getOriginalFilename().contains("srt")) 
				|| (file.getOriginalFilename().contains("zip")||file.getOriginalFilename().contains("txt")) 
				|| (file.getOriginalFilename().contains("7z")||file.getOriginalFilename().contains("xlsx")) 
				|| (file.getOriginalFilename().contains("hwpx")||file.getOriginalFilename().contains("docx")) 
				|| (file.getOriginalFilename().contains("doc")||file.getOriginalFilename().contains("xls"))) {
		
				/** DB 에 파일 저장 **/
				FileData input = new FileData();
					input.setFile_reg_gb( file_reg_gb.code() );
					input.setTar_info_pk( tar_info_pk );
					input.setOrgin_filenm( orgin_filenm );
					input.setSave_filenm( save_filenm );
					input.setFile_save_path( File.separator + file_save_path );
					input.setFile_ext( file_ext.toLowerCase() );
					input.setFile_size( file.getSize() );
				fileMapper.addFile( input );
			  
				return input.getFile_seq();
				
			} else {
				String path = FUNCTION_FILE_SAVE_PATH.apply( now , file_reg_gb );

				/** 이미지 서버 파일 업로드 대상 **/
				if ( file_reg_gb.isUse_image_server() ) {
					dir_path = this.image_file_location.resolve( path );

					/** 일반 파일 업로드 대상 **/
				} else {
					dir_path = this.upload_file_location.resolve( path );
				}
				
				file_path = dir_path.resolve(  save_filenm  );

				String realPath = file_path.toString();
				File file2 = new File(realPath);  //리사이즈할 파일 경로
				Image img = new ImageIcon(ImageIO.read(file2)).getImage(); // 파일 정보 추출

				/** 원본 이미지 가로 길이 **/
				int width = img.getWidth(null);
				/** 원본 이미지 세로 길이 **/
				int height = img.getHeight(null);

				/** 리사이징 이미지 가로 최대길이 설정 **/
				int maxWidth = 1024;
				/** 리사이징 이미지 세로 최대길이 설정 **/
				int maxHeight = 768;

				/** 리사이징 이미지 가로 값 **/
				int resizeWidth;
				/** 리사이징 이미지 세로 값 **/
				int resizeHeight;

				/** 원본 이미지 비율 **/
				int imgRatio = height / width;
				/** 리사이징 최대값 이미지 비율 **/
				int maxRatio = maxHeight / maxWidth;

				if (imgRatio > maxRatio) {
					// height가 기준 비율보다 길다.
					if (height > maxHeight) {
						resizeHeight = maxHeight;
						resizeWidth = Math.round((width * resizeHeight) / height);
					} else {
						resizeWidth = (int) (width*0.9);
						resizeHeight = (int) (height*0.9);
					}

				} else if (imgRatio < maxRatio) {
					// width가 기준 비율보다 길다.
					if (width > maxWidth) {
						resizeWidth = maxWidth;
						resizeHeight = Math.round((height * resizeWidth) / width);
					} else {
					resizeWidth = (int) (width*0.9);
					resizeHeight = (int) (height*0.9);
					}

				} else {
					// 기준 비율과 동일한 경우
					resizeWidth = (int) (width*0.9);
					resizeHeight = (int) (height*0.9);
				}

				width = resizeWidth;
				height = resizeHeight;

				InputStream inputStream = new FileInputStream(file2);
				BufferedImage resizedImage = resize(inputStream ,resizeWidth , resizeHeight );
				// 리사이즈 실행 메소드에 값을 넘겨준다.
				String resizeNewFileNm = FUNCTION_FILE_SAVE_NAME.apply( now,  null );
				String resizeFilePath = dir_path.resolve(  resizeNewFileNm  ).toString();
				ImageIO.write(resizedImage, file_ext, new File(resizeFilePath));
				/** 리사이징 한 이미지 파일을 DB 에 파일 저장 **/
				FileData input = new FileData();
					input.setFile_reg_gb( file_reg_gb.code() );
					input.setTar_info_pk( tar_info_pk );
					input.setOrgin_filenm( orgin_filenm );
					input.setSave_filenm( resizeNewFileNm );
					input.setFile_save_path( File.separator + file_save_path );
					input.setFile_ext( file_ext.toLowerCase() );
					input.setFile_size( new File(resizeFilePath).length() );
				fileMapper.addFile( input );

				inputStream.close();

				file2.delete();
				return input.getFile_seq();
			}	
					
					
		} catch (Exception e) {
			/** 파일 업로드에 실패했습니다.**/
        	throw new ErrorMessageException("file.upload.fail", original_name );
		}

	}
	
	
	/** 신규 파일들 저장 **/
	public void addFiles( FILE_REG_GB file_reg_gb, String tar_info_pk, List<MultipartFile> files ) {
		/** 업로드 된 파일 카운트 **/
		AtomicInteger upload_file_count = new AtomicInteger();
		if( CollectionUtils.isNotEmpty(files) ) {
			for (MultipartFile file : files ) {
					Integer save_file_seq = this.saveFileOnce(file_reg_gb, tar_info_pk, file);
					
					if( save_file_seq != null ) {
						upload_file_count.incrementAndGet();
					}
			
			}
			
		}

		if( file_reg_gb.hasCount() ) {
			int file_cnt = upload_file_count.get();
			fileMapper.modifyTableFileCnt( file_reg_gb,  tar_info_pk, file_cnt );
		}
	}

	/**
	 * 파일 재정렬 처리를 수행한다.
	 * @param reAlignFileList
	 */
	public void modifyFiles(  FILE_REG_GB file_reg_gb, String tar_info_pk, ReAlignFileList re_align_file_list ) {
		Preconditions.checkNotNull( re_align_file_list, "re_align_file_list IS NULL..." );

		/** 현재 DB 저장 파일 시퀀스들  **/
		List<Integer> old_file_seqs = StreamUtils.toStream( this.getFiles( file_reg_gb, tar_info_pk )  )
														  .map( FileData::getFile_seq )
														  .collect( Collectors.toList() );
		if( ! re_align_file_list.isValidFileSeqs( old_file_seqs ) ) {
			/**존재하지않는 파일 정보입니다 **/
			throw new ErrorMessageException( "file.none" );
		}

		/** 삭제할 현재 파일 이미지 seq **/
		List<Integer> remove_file_seqs = re_align_file_list.getRemoveFileSeqs( old_file_seqs );

		/** 이미지 삭제 처리**/
		if( CollectionUtils.isNotEmpty( remove_file_seqs ) ) {
			this.removeFile(file_reg_gb, tar_info_pk, remove_file_seqs );
		}

		AtomicInteger expo_sort_integer = new AtomicInteger();

		/** 신규 파일들 업로드 & 소팅 변경 처리  **/
		StreamUtils.toStream( re_align_file_list )
					.forEach( reAlign -> {
						MultipartFile file = reAlign.getFile();
						Integer file_seq = null;

						if( file != null ) {
							/** 신규 파일 등록 처리  **/
							file_seq = this.saveFileOnce( file_reg_gb, tar_info_pk, reAlign.getFile()  );
							
						} else {
							
							file_seq = reAlign.getFile_seq();
							
						}
						/** 파일 정렬순서 변경 **/
						int expo_sort = expo_sort_integer.incrementAndGet();
						fileMapper.modifyExpoSort(file_seq, expo_sort);
					});

		if( file_reg_gb.hasCount() ) {
			int file_cnt = CollectionUtils.size( re_align_file_list );
			fileMapper.modifyTableFileCnt( file_reg_gb,  tar_info_pk, file_cnt );
			
		}
		

	}




    /**  파일의 물리 풀경로를 조회한다. **/
	private static final  BiFunction< FileData, Path, String > GET_FILE_FULL_PATH =
		( f ,path ) -> {
					    	StringBuilder fullFilePath = new StringBuilder();
					        	fullFilePath.append( path.toString() );
					    		fullFilePath.append( f.getFile_save_path() );
						    	fullFilePath.append( f.getSave_filenm() );
					    	return fullFilePath.toString();
						};



	private static final  Function< FileData , String > GET_CONTENT_DISPOSITION	=
			f -> {
					String original_file_name = f.getOrgin_filenm() + "." +  f.getFile_ext();

					StringBuilder result = new StringBuilder();
					String user_agent =
							CommonUtils.getOptionalRequest()
													.map( request -> request.getHeader(HttpHeaders.USER_AGENT) )
													.orElseGet( () -> "" );
					try {
						if( StringUtils.containsAny( user_agent , "MSIE", "Trident" ) ) {
							result.append( "attachment;filename=" );
							result.append( URLEncoder.encode( original_file_name,  StandardCharsets.UTF_8.name()  ).replaceAll("\\+", "%20") );
							result.append( ";" );
						}else {
							result.append( "attachment; filename=\"" );
							result.append( new String( StringUtils.getBytes(original_file_name,  StandardCharsets.UTF_8 ) , StandardCharsets.ISO_8859_1 ) );
							result.append( "\"" );
						}
					}catch( Exception e ) {
						result.append( "attachment; filename=\"" );
						result.append( original_file_name );
						result.append( "\"" );
					}
					return result.toString();
			};


	/** 파일 다운로드 객체 생성 **/
	public ResponseEntity<Resource> downloadOnce( FileData file_data ){

		FILE_REG_GB file_reg_gb = FILE_REG_GB.valueOf( file_data.getFile_reg_gb() );
		/** 파일 유형구분으로 접근할 파일의 PATH 를 조회한다. **/
		Path target_path = 	file_reg_gb.isUse_image_server() ? this.image_file_location :  this.upload_file_location;
        /** 파일의 물리 경로  **/
        String file_full_path = GET_FILE_FULL_PATH.apply( file_data , target_path );

	    	try {
	    		//23.05.19 동영상(mp4) 파일은 서버 저장시 확장자 붙여서 저장으로 변경.
	    		if(file_data.getFile_reg_gb().equals("TB_CONTENS_VIDEO")) {
	    			file_full_path = new StringBuilder(file_full_path).append(".").append(file_data.getFile_ext()).toString();
	    		}
	    		
	    		Path path = Paths.get( file_full_path );

	        	HttpHeaders headers = new HttpHeaders();
	        	headers.add(HttpHeaders.CONTENT_TYPE, "application/octet-stream; charset=utf-8" );
	        	headers.add(HttpHeaders.CONTENT_DISPOSITION, GET_CONTENT_DISPOSITION.apply( file_data ) );

	        	Resource resource =  new InputStreamResource( Files.newInputStream( path ));

	        	return new ResponseEntity<>(resource, headers, HttpStatus.OK);
	    	}catch( Exception e) {
	    		/** 파일다운로드에 실패했습니다. **/
	    		throw new ErrorMessageException("file.download.fail");
	    	}
	}




	private static final  Function< String , String > GET_CONTENT_DISPOSITION2	=
			file_name -> {

					StringBuilder result = new StringBuilder();
					String user_agent =
							CommonUtils.getOptionalRequest()
													.map( request -> request.getHeader(HttpHeaders.USER_AGENT) )
													.orElseGet( () -> "" );
					try {
						if( StringUtils.containsAny( user_agent , "MSIE", "Trident" ) ) {
							result.append( "attachment;filename=" );
							result.append( URLEncoder.encode( file_name,  StandardCharsets.UTF_8.name()  ).replaceAll("\\+", "%20") );
							result.append( ";" );
						}else {
							result.append( "attachment; filename=\"" );
							result.append( new String( StringUtils.getBytes(file_name,  StandardCharsets.UTF_8 ) , StandardCharsets.ISO_8859_1 ) );
							result.append( "\"" );
						}
					}catch( Exception e ) {
						result.append( "attachment; filename=\"" );
						result.append( file_name );
						result.append( "\"" );
					}
					return result.toString();
			};



	public ResponseEntity<Resource> downloadResourceFile( RESOURCE_DOWNLOAD resource_download ){

		String file_name = resource_download.getFile_name();
		String location = resource_download.getLocation();
    	try {

    		HttpHeaders headers = new HttpHeaders();
        	headers.add(HttpHeaders.CONTENT_TYPE, "application/octet-stream; charset=utf-8" );
        	headers.add(HttpHeaders.CONTENT_DISPOSITION, GET_CONTENT_DISPOSITION2.apply( file_name ) );

        	Resource resource =  ConfigUtils.getResource( location );
        	return new ResponseEntity<>(resource, headers, HttpStatus.OK);

    	}catch( Exception e) {
    		/** 파일다운로드에 실패했습니다. **/
    		throw new ErrorMessageException("file.download.fail");
    	}
	}


	/** 대상 조건의 첫 파일을 조회한다.
	 * 	존재하지 않은면 null 응답한다.
	 * **/
	public final FileData getFirstFile( FILE_REG_GB file_reg_gb, String tar_info_pk ) {
		List<FileData> files = this.getFiles(file_reg_gb, tar_info_pk);
		return StreamUtils.toStream( files )
				   .findFirst()
				   .orElseGet( () -> null );
	}
	
	/** 파일 다운로드에 대한 로그를 추가한다. **/
	public void addFileDownloadLog( FILE_DOWN_TYPE file_down_type ) {
		
		String down_type = file_down_type.code();
		
		fileMapper.addFileDownloadLog(down_type);
	}
	

	   
	/** 리사이즈 실행 메소드 **/
	public static BufferedImage resize(InputStream inputStream, int width, int height) 
	   	throws IOException {
	   	
	    BufferedImage inputImage = ImageIO.read(inputStream);  // 받은 이미지 읽기

	    BufferedImage outputImage = new BufferedImage(width, height, inputImage.getType());
	    // 입력받은 리사이즈 길이와 높이 

	    Graphics2D graphics2D = outputImage.createGraphics(); 
	    graphics2D.drawImage(inputImage, 0, 0, width, height, null); // 그리기
	       
	    graphics2D.dispose(); // 자원해제

	    return outputImage;
	}
	
	/** 물리 파일 삭제 **/
	private void deleteRealFileOnce( Integer file_seq ){
		// 삭제할 파일 정보를 확인한다.
		FileData file_data = fileMapper.getDeleteFile(file_seq);
		
		if(file_data.getFile_seq() != null) {
			FILE_REG_GB file_reg_gb = FILE_REG_GB.valueOf( file_data.getFile_reg_gb() );
			/** 파일 유형구분으로 접근할 파일의 PATH 를 조회한다. **/
			Path target_path = 	file_reg_gb.isUse_image_server() ? this.image_file_location :  this.upload_file_location;
			/** 파일의 물리 경로  **/
			String file_full_path = GET_FILE_FULL_PATH.apply( file_data , target_path );
			
			try {
				File deleteFile = new File(file_full_path);
				
				if(deleteFile.exists()) {
					deleteFile.delete(); 
				} 
				
			}catch( Exception e) {
				e.printStackTrace();
			}
		}

	}

	/** 물리 파일 삭제(여러 개) **/
	public void deleteRealFiles( List<Integer> file_seqs) {
		for(Integer file_seq : file_seqs) {
			this.deleteRealFileOnce(file_seq);
		}
	}
	
	
	/** 물리 파일 삭제(여러 개) target_seq 이용  **/
	public void deleteRealFiless( FILE_REG_GB file_reg_gb, List<String> tar_info_pk) {
		List<Integer> file_seqs = new ArrayList<Integer>();
		if(!tar_info_pk.isEmpty()) {
			for(String target_seq : tar_info_pk) {
				List<Integer> seqs = fileMapper.getDeleteFileSeqs(file_reg_gb.code(), target_seq);
				file_seqs.addAll(seqs);
			}
			
			this.deleteRealFiles(file_seqs);
		}
		
	}



}