package egovframework.work.main.model.main;

import java.security.SecureRandom;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class SendMail {
	
	/** 디폴트 포트번호 **/
	private static final int port = 465;
	
	private String host;
	
	private String user_id;
	
	private String email_tail;
	
	private String password;
    
	private Properties props = System.getProperties();
	
	
	// 랜덤 값 생성용 
    private static final String LOWER_CASE = "abcdefghijklmnopqrstuvwxyz";
    private static final String UPPER_CASE = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private static final String DIGITS = "0123456789";
    private static final String SPECIAL_CHARS = "!@#$%^&*()_+=";
	
	// 인증코드 패턴
    // 규칙1 : 영어 소문자, 대문자, 숫자, 특수문자 1자리 이상씩 포함된 10자리 랜덤 값 패턴 검증
    private static final String GENRATE_CODE = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+-=])[a-zA-Z!@#$%^&*()_+-=0-9]{10}$";
	
	private boolean setEnv(){
		props.put("mail.smtp.host", host);  
		props.put("mail.smtp.port", port);  
		props.put("mail.smtp.auth", "true");  
		props.put("mail.smtp.ssl.enable", "true");  
		props.put("mail.smtp.ssl.trust", host);  
		return true;
	}
	
    /** 파일 없이 전송 **/
	public boolean sendMail(String receiver, String title, String text) throws Exception{
		setEnv();
		MimeMessage msg = sendingHead();
		sendingBody(msg, receiver, title, text);
		
		/** 내용을 TEXT 형식으로 전송
		msg.setText(text);
		**/
		
		/** 내용을 HTML 형식으로 전송 **/
		msg.setContent(text,"text/html; charset=euc-kr");
		
        Transport.send(msg);	
		return true;
	}

	/** 파일과 함께 전송 **/
	public boolean sendMail(String receiver,String title, String text, String filePath, String fileName) throws Exception{
		
		setEnv();
		MimeMessage msg = sendingHead();
		sendingBody(msg, receiver, title, text);
		
		if(filePath != null && filePath.length() > 0){  
	        Multipart multipart = new MimeMultipart();
	        MimeBodyPart textBodyPart = new MimeBodyPart();
	        textBodyPart.setText(text,"UTF-8");
	        MimeBodyPart attachmentBodyPart= new MimeBodyPart();
	        DataSource source = new FileDataSource(filePath); 
	        attachmentBodyPart.setDataHandler(new DataHandler(source));
	        attachmentBodyPart.setFileName(MimeUtility.encodeText(fileName, "UTF-8", null));
	        multipart.addBodyPart(textBodyPart);  // add the text part
	        multipart.addBodyPart(attachmentBodyPart); // add the attachement part
	        msg.setContent(multipart);			
		}	
		Transport.send(msg);	
        return true;
	}
	
	private MimeMessage sendingHead(){
		Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
			String id = user_id;
			String pw = password;
			protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
				return new javax.mail.PasswordAuthentication(id, pw);
			}
		});
		/** for debug **/
		session.setDebug(true);
		
		/** MimeMessage 생성 **/
		MimeMessage msg = new MimeMessage(session);
		
		return msg;
	}

	private void sendingBody(MimeMessage msg, String receiver, String title, String text) throws Exception{
		/** 발신자 세팅, 보내는 사람의 이메일주소를 한번 더 입력 ( 이때 이메일은 반드시 풀주소여야 함 ) **/
		msg.setFrom(new InternetAddress(user_id + email_tail));  
		
		/** 수신자 세팅 **/
		msg.setRecipient(Message.RecipientType.TO, new InternetAddress(receiver));  
		
		/** 제목 세팅 **/
		msg.setSubject(title);  
	}
	
	
	/***
	 * 인증코드 생성
	 * @param size
	 * @return String(code)
	 */
	public String generateVerificationCode(int size) {
		SecureRandom random = new SecureRandom();
		StringBuilder codeBuilder = new StringBuilder();
		List<String> charCategories = Arrays.asList(LOWER_CASE, UPPER_CASE, DIGITS, SPECIAL_CHARS);
		
		
		for(int i = 0 ; i < size ; i++) {
			String charCategory = charCategories.get(random.nextInt(charCategories.size()));
			int position = random.nextInt(charCategory.length());
			char randomChar = charCategory.charAt(position);
			codeBuilder.append(randomChar);
		}
		
		String code = codeBuilder.toString();
        // Ensure that code contains at least one character from each group
        if (code.matches(GENRATE_CODE)) {
            return code;
        } else {
            return generateVerificationCode(size);
        }
	}
	
}
