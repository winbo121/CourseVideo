package egovframework.work.notice.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import egovframework.work.notice.model.Notice;

@Mapper
public interface KotechNoticeMapper {

	void insertNotice(Notice notice);

	List<Map<String, Object>> getFixedNoticeList(Notice notice);

	List<Map<String, Object>> getNoticeList(Notice notice);

	Integer getTotalCount(Notice notice);

	Integer noticePagingTotalCount(Notice notice);

	List<Notice> noticePagingPagedList(Notice notice);

	Notice getNoticeList(Map<String, Object> param);

	Notice getNotice(Map<String, Object> param);

	void modifyNotice(Notice notice);

	List<Map<String, Integer>> getNoticeFileSeq(Notice notice);

	Integer deleteNotice(Map<String, Object> param);

	Integer search_count_increase(Integer noti_seq);

	Notice selectNoticeDetail(Integer noti_seq);

	Integer maxNoticeSeq(Integer notice_seq);

	Integer minNoticeSeq(Integer notice_seq);

	List<Map<String, Object>> getFixNoticeListCnt(Notice notice);

	List<Map<String, Object>> getNoticeGb(Notice notice);

	List<Notice> getSideFixList(List<String> seq);

	List<Notice> getFixedNoticeList2(Integer notice_seq);

	List<Notice> getSideNoticeList(Integer notice_seq);

	void deleteFixNotice(Notice notice);

	int updateSort(Notice notice);

	void sortInit();

	int fixCnt();

}
