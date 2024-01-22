package egovframework.work.notice.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.nhncorp.lucy.security.xss.XssPreventer;

import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.collections.CollectionUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.transaction.Transactional;


import egovframework.common.base.BaseService;
import egovframework.common.component.file.FileComponent;
import egovframework.common.component.file.attribute.ReAlignFileList;
import egovframework.common.component.file.model.FileData;
import egovframework.common.constrant.EnumCodes.FILE_REG_GB;
import egovframework.common.error.exception.ErrorMessageException;
import egovframework.common.error.util.jsp.paging.JspPagingResult;
import egovframework.work.notice.mapper.KotechNoticeMapper;
import egovframework.work.notice.model.Notice;

@Service
public class KotechNoticeService extends BaseService{
	
	@Autowired
	protected KotechNoticeMapper noticeMapper;
	
	@Autowired
	private FileComponent fileComponent;

	@Transactional
	public void insertNotice(Notice notice) {
		
//		XssSaxFilter filter = XssSaxFilter.getInstance("lucy-xss-superset-sax.xml");
		notice.setContents(XssPreventer.escape(notice.getContents()));
		noticeMapper.insertNotice(notice);
		MultipartFile[] files = notice.getFiles();
		MultipartFile[] thumb = notice.getThumb_files();
		Integer[] delete_files = notice.getDelete_files();
		String tar_info_pk = notice.getNotice_seq().toString();
		
		
		if (ObjectUtils.isNotEmpty(files)) {
			fileComponent.addFiles(FILE_REG_GB.TS_NOTICE, tar_info_pk,  Arrays.asList(files));
		}
		if (ObjectUtils.isNotEmpty(thumb)) {
			fileComponent.addFiles(FILE_REG_GB.TS_NOTICE_THUMB, tar_info_pk,  Arrays.asList(thumb));
		}
	}
	
	public List<Map<String, Object>> getFixedNoticeList(Notice notice) {
		// TODO Auto-generated method stub
		FileData thumb = fileComponent.getFirstFile(FILE_REG_GB.TS_NOTICE_THUMB,  String.valueOf(notice.getNotice_seq()));
		notice.setThumb(thumb);
		return noticeMapper.getFixedNoticeList(notice);
	}

	public List<Map<String, Object>> getNoticeList(Notice notice) {
		// TODO Auto-generated method stub
		return noticeMapper.getNoticeList(notice);
	}

	public Integer getTotalCount(Notice notice) {
		// TODO Auto-generated method stub
		return noticeMapper.getTotalCount(notice);
	}

	public JspPagingResult<Notice> noticePaging(Notice notice) {
		Integer totalCount = noticeMapper.noticePagingTotalCount( notice );
		List<Notice> pagedList = noticeMapper.noticePagingPagedList(notice);
		return super.convertJspPaging(notice, pagedList, totalCount);
	}

	public Notice getNotice(Map<String, Object> param) {
		return noticeMapper.getNotice(param);
	}

	public void modifyNotice(Notice notice) {
		notice.setContents(XssPreventer.escape(notice.getContents()));
		noticeMapper.modifyNotice(notice);
		MultipartFile[] files = notice.getFiles();
		MultipartFile[] thumb = notice.getThumb_files();
		Integer[] delete_files = notice.getDelete_files();
		String tar_info_pk = notice.getNotice_seq().toString();
		
		//업로드 파일 수정이 없을땐 아래의 로직을 타지않음.
				if(ObjectUtils.isNotEmpty( notice.getFiles() )) {
					/** 기존 파일 일련번호 **/
					List<String> file_seqs = notice.getFile_seqs();
					/** 수정시에 추가된 파일 들 **/
					MultipartFile[] upload_files = notice.getFiles();

					/** 파일이 수정되어야 할때 **/
					if( !CollectionUtils.isEmpty(file_seqs) && !ObjectUtils.isEmpty(upload_files) ) {
						/** 파일 재정렬 객체 생성 **/
						ReAlignFileList re_align_file_list = ReAlignFileList.of( file_seqs, upload_files );

						/** 글수정시에 아래와 같이 파일업로드 **/
						fileComponent.modifyFiles(FILE_REG_GB.TS_NOTICE, tar_info_pk, re_align_file_list);
						
					/** 수정될 파일이 없고 추가만 되어야 할때 **/
					} else if(CollectionUtils.isEmpty(file_seqs) && !ObjectUtils.isEmpty(upload_files)) {
						fileComponent.addFiles(FILE_REG_GB.TS_NOTICE, tar_info_pk, Arrays.asList( upload_files ));
					}
					
				}
				if(ObjectUtils.isNotEmpty( notice.getThumb_files() )) {
					/** 기존 파일 일련번호 **/
					List<String> file_seqs = notice.getFile_seqs();
					/** 수정시에 추가된 파일 들 **/
					MultipartFile[] upload_files = notice.getThumb_files();
					
					/** 파일이 수정되어야 할때 **/
					if( !CollectionUtils.isEmpty(file_seqs) && !ObjectUtils.isEmpty(upload_files) ) {
						/** 파일 재정렬 객체 생성 **/
						ReAlignFileList re_align_file_list = ReAlignFileList.of( file_seqs, upload_files );
						
						/** 글수정시에 아래와 같이 파일업로드 **/
						fileComponent.modifyFiles(FILE_REG_GB.TS_NOTICE_THUMB, tar_info_pk, re_align_file_list);
						
						/** 수정될 파일이 없고 추가만 되어야 할때 **/
					} else if(CollectionUtils.isEmpty(file_seqs) && !ObjectUtils.isEmpty(upload_files)) {
						fileComponent.addFiles(FILE_REG_GB.TS_NOTICE_THUMB, tar_info_pk, Arrays.asList( upload_files ));
					}
					
				}
	}

	public void deleteNoticeFile(Notice notice) {
		
		Integer file_seq = notice.getFile_seq();
		Integer noti_seq = notice.getNotice_seq();
		List<Integer> file_seq_list = Arrays.asList( file_seq );
		List<String> noti_seq_list = new ArrayList<String>();
		noti_seq_list.add( noti_seq.toString() );
		fileComponent.removeFile( FILE_REG_GB.TS_NOTICE, notice.getNotice_seq().toString(), file_seq_list );
		fileComponent.removeFile( FILE_REG_GB.TS_NOTICE_THUMB, notice.getNotice_seq().toString(), file_seq_list );
		fileComponent.deleteRealFiless(FILE_REG_GB.TS_NOTICE_THUMB,noti_seq_list);
		fileComponent.deleteRealFiless(FILE_REG_GB.TS_NOTICE,noti_seq_list);
		
	}

	@Transactional
	public Integer deleteNotice(Notice notice, HttpServletRequest request) {
		Integer cnt = 0;
		Map<String, Object> param = new HashMap<>();
		param.put("upd_user", notice.getUpd_user());
		
		
		 for (Integer del_item : notice.getDel_items()) { 
			 param.put("notice_seq", del_item); 
			 cnt += noticeMapper.deleteNotice(param); 
		 }
			notice.setNotice_seq(notice.getDel_items().get(0));
			List<Map<String,Integer>> file_seq = noticeMapper.getNoticeFileSeq(notice);
		 
		 List<String> noti_seq_list = new ArrayList<String>();
		 List<Integer> file_seq_list = new ArrayList<Integer>();
		 noti_seq_list.add(notice.getDel_items().get(0).toString());
		 for (int i = 0; i < file_seq.size(); i++) {
			 file_seq_list.add(file_seq.get(i).get("file_seq"));
			 fileComponent.removeFile( FILE_REG_GB.TS_NOTICE, notice.getDel_items().get(0).toString(), file_seq_list );
			 fileComponent.deleteRealFiless(FILE_REG_GB.TS_NOTICE,noti_seq_list); 
		}
		 fileComponent.removeFile( FILE_REG_GB.TS_NOTICE_THUMB, notice.getDel_items().get(0).toString(), file_seq_list );
		 fileComponent.deleteRealFiless(FILE_REG_GB.TS_NOTICE_THUMB,noti_seq_list); 
		return cnt;
	}

	public Notice selectNoticeDetail(Integer noti_seq) {
		// 검색되기 전 조회수 증가
		Integer update_done = noticeMapper.search_count_increase(noti_seq);
		if(update_done != null) {
		
		}
		
		Notice noticeDetail = noticeMapper.selectNoticeDetail(noti_seq);
		if( ObjectUtils.isEmpty( noticeDetail ) ) {
			throw new ErrorMessageException("com.none.data", "공지사항");
		}
		List<FileData> files = fileComponent.getFiles(FILE_REG_GB.TS_NOTICE,  String.valueOf(noti_seq));
		noticeDetail.setFileList(files);
		
		FileData thumb = fileComponent.getFirstFile(FILE_REG_GB.TS_NOTICE_THUMB,  String.valueOf(noti_seq));
		noticeDetail.setThumb(thumb);
		noticeDetail.setContents(XssPreventer.unescape(noticeDetail.getContents()));		 
		return noticeDetail;
	}

	public Integer maxNoticeSeq(Integer notice_seq) {
		// TODO Auto-generated method stub
		return noticeMapper.maxNoticeSeq(notice_seq);
	}

	public Integer minNoticeSeq(Integer notice_seq) {
		// TODO Auto-generated method stub
		return noticeMapper.minNoticeSeq(notice_seq);
	}

	public List<Map<String, Object>> getFixNoticeListCnt(Notice notice) {
		// TODO Auto-generated method stub
		return noticeMapper.getFixNoticeListCnt(notice);
	}

	public List<Map<String, Object>> getNoticeGb(Notice notice) {
		// TODO Auto-generated method stub
		return noticeMapper.getNoticeGb(notice);
	}

	public List<Notice> getSideFixList(List<String> seq) {
		// TODO Auto-generated method stub
		return noticeMapper.getSideFixList(seq);
	}

	public List<Notice> getFixedNoticeList2(Integer notice_seq) {
		
			List<Notice> sideNotice = noticeMapper.getFixedNoticeList2(notice_seq);
			/*
			 * if( ObjectUtils.isEmpty( sideNotice ) ) { throw new
			 * ErrorMessageException("com.none.data", "공지사항"); }
			 */
			List<FileData> files = null;
			FileData thumb = null;
			for (int i = 0; i < sideNotice.size(); i++) {
				Notice notice = sideNotice.get(i);
				files = fileComponent.getFiles(FILE_REG_GB.TS_NOTICE,  String.valueOf(sideNotice.get(i).getNotice_seq()));
				thumb = fileComponent.getFirstFile(FILE_REG_GB.TS_NOTICE_THUMB,  String.valueOf(sideNotice.get(i).getNotice_seq()));

				notice.setFileList(files);
				notice.setThumb(thumb);
			}
			
			return sideNotice;
	}

	public List<Notice> getSideNoticeList(Integer notice_seq) {
		List<Notice> sideNoticeList = noticeMapper.getSideNoticeList(notice_seq);
		
		return sideNoticeList;
	}

	public void deleteFixNotice(Notice notice) {
		
		noticeMapper.deleteFixNotice(notice);
		
	}

	public int updateSort(Notice notice) {
	
		return noticeMapper.updateSort(notice);
	}

	public void sortInit() {
		noticeMapper.sortInit();
	}

	public int fixCnt() {
		return noticeMapper.fixCnt();
	}
}
