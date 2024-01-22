package egovframework.work.course.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import egovframework.common.base.BaseService;
import egovframework.common.component.file.FileComponent;
import egovframework.common.component.file.attribute.ReAlignFileList;
import egovframework.common.component.file.model.FileData;
import egovframework.common.constrant.EnumCodes.FILE_REG_GB;
import egovframework.common.error.util.jsp.paging.JspPagingResult;
import egovframework.common.util.LocalThread;
import egovframework.work.course.mapper.ContentsManageMapper;
import egovframework.work.course.model.Contents;
import egovframework.work.course.model.ContentsSearch;

@Service
public class ContentsManageService extends BaseService {
	
	/** 대상 파일 유형  **/
	private static final FILE_REG_GB TARGET_FILE_REG_GB_VIDEO = FILE_REG_GB.TB_CONTENS_VIDEO;
	private static final FILE_REG_GB TARGET_FILE_REG_GB_SUB = FILE_REG_GB.TB_CONTENS_SUBTITLE;
	private static final FILE_REG_GB TARGET_FILE_REG_GB_IMAGE = FILE_REG_GB.TB_CONTENS_THUMBNAIL;
	

	@Autowired
	ContentsManageMapper contentsManageMapper;
	
	@Autowired
	private FileComponent fileComponent;
	
	/** JSP 페이징 리스트 조회 **/
	public JspPagingResult<Map<String, Object>> contentsJspPaging(ContentsSearch search){
		Integer totalCount = contentsManageMapper.getContentsTotalCount(search);
		List<Map<String,Object>> pagedList = contentsManageMapper.getContentsJspPagedList(search);
		return super.convertJspPaging(search, pagedList, totalCount);
	}
	/** JSP 엑셀 다운로드 **/
	public List<Map<String, Object>> jspExcel( ContentsSearch search ){
		return contentsManageMapper.getContentsJspPagedList(search);
	}

	
	/** 콘텐츠 등록 **/
	public Integer insertContents(Contents contents) {
		return contentsManageMapper.insertContents(contents); 
	}
	
	/** 콘텐츠 조회 **/
	public Contents getContents(int contents_seq) {
		return contentsManageMapper.getContents(contents_seq);
	}
	
	/** 콘텐츠 수정 **/
	public Integer updateContents(Contents contents) {
		//영상타입이 MP4가 아니면 영상정보 초기화 및 영상, 자막 첨부파일 삭제로 변경.
		if(!contents.getVod_gb().equals("M")) {
			contents.setWidth_size(null);
			contents.setHeight_size(null);
			contents.setVod_time_sec(null);
			String targetSeq = Integer.toString(contents.getContents_seq());
			List<String> targetSeqs = new ArrayList<String>();
			targetSeqs.add(targetSeq);
			fileComponent.removeFile(TARGET_FILE_REG_GB_VIDEO, targetSeq);
			fileComponent.deleteRealFiless(TARGET_FILE_REG_GB_VIDEO, targetSeqs);
			fileComponent.removeFile(TARGET_FILE_REG_GB_SUB, targetSeq);
			fileComponent.deleteRealFiless(TARGET_FILE_REG_GB_SUB, targetSeqs);
		}
		//영상타입이 외부영상이 아니면 url 삭제.
		if(!contents.getVod_gb().equals("O") && !contents.getVod_gb().equals("Y")) {
			contents.setVod_url(null);
		}
		
		int mappedCnt = contentsManageMapper.getMappedCourseList(contents.getContents_seq());
		if(mappedCnt > 0) {
			// 연결된 강좌 존재시 영상구분 변경 불가
			contents.setVod_gb("");
		}
		
		return contentsManageMapper.updateContents(contents); 
	}
	
	/** 콘텐츠 삭제 **/
	@Transactional
	public boolean deleteContents(List<Integer> del_seqs) {
		boolean result = false;
		int cnt = 0;
		int upload = 0;
		List<String> target_seqs = new ArrayList<String>();
		
		//Login User setting
		String loginId = LocalThread.getLoginId();
		Contents contents = new Contents();
		contents.setUpd_user(loginId);
		
		for(int seq : del_seqs) {
			upload = 0;
			contents.setContents_seq(seq);
			upload = contentsManageMapper.deleteContents(contents);
			if(upload > 0) {
				List<Map<String, Object>> courseList = contentsManageMapper.getDeleteCourseList(seq);
				if(!courseList.isEmpty()) {
					Map<String, Object> param = new HashMap<String, Object>();
					param.put("upd_user", loginId);
					int round = 0;
					for(Map<String, Object> rMap : courseList) {
						// 연결된 매핑 삭제
						param.put("contents_mapped_seq", rMap.get("contents_mapped_seq"));
						contentsManageMapper.deleteContentsMapped(param);
						
						round = Integer.parseInt(rMap.get("course_round").toString());
						param.put("course_seq", rMap.get("course_seq"));
						
						// 강좌의 콘텐츠가 하나면 콘텐츠 삭제
						if(round == 1) {
							contentsManageMapper.deleteCourse(param);
						} else if(round > 1) {
							contentsManageMapper.updateCourseRound(param);
						}
					}
				}
				
				target_seqs.add(Integer.toString(seq));
				cnt++;
			}
		}
		
		if(cnt == del_seqs.size()) {
			result = true;
			
			fileComponent.removeFiless(TARGET_FILE_REG_GB_VIDEO, target_seqs);
			fileComponent.removeFiless(TARGET_FILE_REG_GB_IMAGE, target_seqs);
			fileComponent.removeFiless(TARGET_FILE_REG_GB_SUB, target_seqs);
			
			//실제 파일 삭제
			fileComponent.deleteRealFiless(TARGET_FILE_REG_GB_VIDEO, target_seqs);
			fileComponent.deleteRealFiless(TARGET_FILE_REG_GB_IMAGE, target_seqs);
			fileComponent.deleteRealFiless(TARGET_FILE_REG_GB_SUB, target_seqs);
		};
		
		return result;
	}
	
	/** vod파일 리스트 조회 **/
	public  List<FileData> getFilesVod(String targetSeq) {
		return fileComponent.getFiles(TARGET_FILE_REG_GB_VIDEO, targetSeq);
	}
	
	/** vod 파일 리스트 조회 **/
	public  List<FileData> getFilesSub(String targetSeq) {
		return fileComponent.getFiles(TARGET_FILE_REG_GB_SUB, targetSeq);
	}
	
	/** vod 파일 등록  **/
	@Transactional
	public boolean addVodFileupload( Contents contents) {
		boolean result = false;
		
		MultipartFile[] upload_files = contents.getUpload_files();
		MultipartFile[] upload_images = contents.getUpload_images();
		String targetSeq = contents.getContents_seq().toString();
		
		try {
			/** 글등록시에 아래와 같이 파일업로드 **/
			fileComponent.addFiles(TARGET_FILE_REG_GB_VIDEO, targetSeq, Arrays.asList( upload_files ) );
			
			// 썸네일
			fileComponent.addFiles(TARGET_FILE_REG_GB_IMAGE, targetSeq, Arrays.asList( upload_images ) );
			
			result = true;
		} catch (Exception e) {
			e.printStackTrace();
			result = false;
		}
		
		return result;
	}
	
	/** 자막 파일 등록  **/
	@Transactional
	public boolean addSubFileupload( Contents contents) {
		boolean result = false;
		int isExist = 0;
		
		MultipartFile[] upload_subs = contents.getUpload_subs();
		String targetSeq = contents.getContents_seq().toString();
		
		try {
			/** 글등록시에 아래와 같이 자막업로드 **/
			if(upload_subs != null && upload_subs.length > 0 ) {
				isExist = this.checkSubFile(contents);
				if(isExist > 0) {
					List<String> target_seqs = new ArrayList<String>();
					target_seqs.add(targetSeq);
					fileComponent.removeFiless(TARGET_FILE_REG_GB_SUB, target_seqs);
					fileComponent.deleteRealFiless(TARGET_FILE_REG_GB_SUB, target_seqs);
				}
				fileComponent.addFiles(TARGET_FILE_REG_GB_SUB, targetSeq, Arrays.asList( upload_subs ) );
			}
			result = true;
		} catch (Exception e) {
			e.printStackTrace();
			result = false;
		}
		
		return result;
	}

	/** 파일 수정 **/
	@Transactional
	public void modifyFileupload( ReAlignFileList re_align_file_list, String targetSeq) {

		/** 글수정시에 아래와 같이 파일업로드 **/
		fileComponent.modifyFiles(TARGET_FILE_REG_GB_VIDEO, targetSeq, re_align_file_list);
		fileComponent.modifyFiles(TARGET_FILE_REG_GB_IMAGE, targetSeq, re_align_file_list);

	}


	/** 파일 삭제  **/
	@Transactional
	public void removeFileupload( Contents contents) {
		String targetSeq = contents.getContents_seq().toString();
		List<Integer> vod_seq_list = contents.getDel_vod_file_seqs();
		List<Integer> sub_seq_list = contents.getDel_sub_file_seqs();
		if(vod_seq_list != null && !vod_seq_list.isEmpty()) {
			fileComponent.removeFile( TARGET_FILE_REG_GB_VIDEO, targetSeq, vod_seq_list );
			fileComponent.deleteRealFiles(vod_seq_list);
			
			List<String> targetSeqs = new ArrayList<String>();
			targetSeqs.add(targetSeq);
			fileComponent.removeFile(TARGET_FILE_REG_GB_IMAGE, targetSeq);
			fileComponent.deleteRealFiless(TARGET_FILE_REG_GB_IMAGE, targetSeqs);
		}
		if(sub_seq_list != null && !sub_seq_list.isEmpty()) {
			fileComponent.removeFile( TARGET_FILE_REG_GB_SUB, targetSeq, sub_seq_list );
			fileComponent.deleteRealFiles(sub_seq_list);
		}
	}
	
	/** VOD 파일 확인 **/
	public Integer checkVodFile(Contents contents) {
		Map<String, Object> param = new HashMap<>();
		String targetSeq = contents.getContents_seq().toString();
		
		param.put("target_seq", targetSeq);
		param.put("file_reg_gb", TARGET_FILE_REG_GB_VIDEO);
		
		return contentsManageMapper.checkFile(param);
	}
	
	/** 자막 파일 확인 **/
	public Integer checkSubFile(Contents contents) {
		Map<String, Object> param = new HashMap<>();
		String targetSeq = contents.getContents_seq().toString();
		
		param.put("target_seq", targetSeq);
		param.put("file_reg_gb", TARGET_FILE_REG_GB_SUB);
		
		return contentsManageMapper.checkFile(param);
	}
	
	/** 콘텐츠 운영중 강좌 list **/
	public List<Map<String, Object>> getActivatedCourseList(int contents_seq) {
		return contentsManageMapper.getActivatedCourseList(contents_seq);
	};
	
	/** 콘텐츠 연결된 강좌 list **/
	public Integer getMappedCourseList(int contents_seq) {
		return contentsManageMapper.getMappedCourseList(contents_seq);
	};
}
