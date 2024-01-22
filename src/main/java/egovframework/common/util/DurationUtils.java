package egovframework.common.util;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.Optional;

import org.apache.commons.lang3.StringUtils;

import lombok.AccessLevel;
import lombok.NoArgsConstructor;

@NoArgsConstructor( access = AccessLevel.PRIVATE  )
public class DurationUtils {


	/** 시간, 날짜 형식 유효성 체크 **/
	public static boolean isValidFormat( String time, String pattern ) {
		 try {
				 SimpleDateFormat dateFormat = new SimpleDateFormat( pattern );
				 Date date = dateFormat.parse( time );
				 SimpleDateFormat pOutformatter =  new SimpleDateFormat ( pattern , java.util.Locale.KOREA);
				 String str_date = pOutformatter.format( date );

				 return StringUtils.equals( time, str_date );
		 }catch( Exception e) {
			 return false;
		 }
	}

	/** String -> DateTimeFormatter  **/
	public static DateTimeFormatter getDataTimeFormatter( String pattern ) {
		return DateTimeFormatter.ofPattern( pattern );
	}

	/** LocalDateTime -> String **/
	public static String getTimeString( LocalDateTime time, String pattern ) {
		return Optional.ofNullable( time )
							.map( l_time -> l_time.format( getDataTimeFormatter(pattern) ) )
							.orElse( null );
	}

	/** String -> LocalDateTime **/
	public static LocalDateTime getStringTime( String time, String pattern ) {
		return Optional.ofNullable( time )
							.map( str ->  LocalDateTime.parse(str, getDataTimeFormatter(pattern) )    )
							.orElse( null );
	}

	/** LocalDate -> String **/
	public static String getDateString( LocalDate date , String pattern ) {
		return Optional.ofNullable( date )
							 .map( l_date -> l_date.format( getDataTimeFormatter(pattern) ) )
							 .orElse(null);
	}

	/** String -> LocalDate **/
	public static LocalDate getStringDate( String date, String pattern ) {
		return Optional.ofNullable( date )
							 .map( str -> LocalDate.parse(str, getDataTimeFormatter(pattern) )  )
							 .orElse( null );
	}

	/** Timestamp -> String **/
	public static String getTimeStampString( Timestamp timestamp , String pattern) {

		LocalDateTime time = Optional.ofNullable( timestamp )
											  .map( Timestamp::toLocalDateTime )
											  .orElse(null);

		return getTimeString(time, pattern);
	}


}
