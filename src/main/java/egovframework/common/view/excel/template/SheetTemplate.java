package egovframework.common.view.excel.template;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import com.google.common.collect.Lists;

import egovframework.common.view.excel.template.header.SheetHeader;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor( staticName = "of" )
@NoArgsConstructor( staticName = "of" )
public final class SheetTemplate implements Serializable {

	private static final long serialVersionUID = -1909456675249313321L;

	/** 시트명 **/
	@Getter @NonNull
	private String seetName;

	/** 시트 타이틀 **/
	@Getter @NonNull
	private String seetTitle;

	/** 데이터 리스트 **/
	@Getter @NonNull
	private List< Map<String,Object> > dataList;

	/** SHEET HEADER 정보 **/
	@Getter
	protected List<SheetHeader> sheetHeaderList = Lists.newArrayList();


	/** SHEET HEADER 세팅 **/
	public SheetTemplate addSheetHeader( String headerName, String headerKey ){
		this.sheetHeaderList.add( SheetHeader.of( headerName, headerKey, false ) );
		return this;
	}
	/** SHEET HEADER (HTML) 세팅 **/
	public SheetTemplate addSheetHtmlHeader( String headerName, String headerKey ) {
		this.sheetHeaderList.add( SheetHeader.of( headerName, headerKey, true ) );
		return this;
	}


	/** ROW 시작 **/
	protected Integer _rownum = 4;
	/** 컬럼 시작 **/
	protected Integer _column =1;

	protected Integer _title_row = 1;
	protected Integer _nowtime_row = 2;


	public List< List<Object> > convertWorkbook( Sheet sheet ) {
		List< List<Object>> sheet_datas = Lists.newArrayList();

		Iterator<Row> rowItr = sheet.iterator();


		/** BODY START ROW INDEX **/
		Integer body_start_row_index = Integer.valueOf( this._rownum + 1 );
		/** BODY START CELL INDEX **/
		Integer body_start_cell_index = Integer.valueOf( this._column );


		 while( rowItr.hasNext() ) {
			 Row row = rowItr.next();
			 Integer row_num = row.getRowNum();

			 if( body_start_row_index  <= row_num  ) {
				 Iterator<Cell> cellItr = row.cellIterator();

				 /**  ROW DATAS **/
				 List<Object> row_datas = Lists.newArrayList();

				 while( cellItr.hasNext() ) {
					 Cell cell = cellItr.next();
					 Integer cell_index = cell.getColumnIndex();

					 if( body_start_cell_index <= cell_index ) {

						 Object cell_value = getCellValue(cell);
						 if( cell_value instanceof Double ) {
							 try {
								 Double cell_double_value = (Double) cell_value;
								 cell_value = cell_double_value.intValue();
							 }catch( Exception e) {}
						 }

						 row_datas.add( cell_value );

					 }

				 }
				 sheet_datas.add( row_datas );

			 }

		 }

		return sheet_datas;
	}



	/** SHEET 생성  **/
	protected Sheet createSheet( Workbook workbook, String now_time ) {
		String seetName = StringUtils.defaultIfEmpty( this.seetName, "Sheet1" );
		String seetTitle = StringUtils.defaultIfEmpty( this.seetTitle, "" );

		Sheet sheet = workbook.createSheet( seetName );

		Integer header_size = CollectionUtils.size( this.sheetHeaderList );

		/** 제목 **/
		Row title_row = sheet.createRow( this._title_row );
		Cell title_cell = title_row.createCell( this._column );
		sheet.addMergedRegion(new CellRangeAddress( this._title_row, this._title_row, this._column, (header_size -1 + this._column ) ) );

		CellStyle style = 	getTitleStyle(workbook);
		style.setWrapText( true );
		style.setAlignment( HorizontalAlignment.LEFT );

		title_cell.setCellStyle( style   );
		title_cell.setCellValue( seetTitle );

		/** 현재시간 **/
		Row nowtime_row = sheet.createRow( this._nowtime_row );
		nowtime_row.createCell( this._column );
		Cell nowtime_cell = nowtime_row.createCell( this._column );
		sheet.addMergedRegion(new CellRangeAddress( this._nowtime_row, this._nowtime_row, this._column, (header_size -1 + this._column ) ) );
		nowtime_cell.setCellStyle( getNowTimeStyle( workbook ) );
		nowtime_cell.setCellValue( now_time );

		return sheet;
	}

	public Sheet createExcel( Workbook workbook, String now_time ) {

		Sheet sheet = this.createSheet(workbook, now_time);


		/** HEADER 생성 **/
		Row header_row = sheet.createRow( this._rownum );
		if( CollectionUtils.isNotEmpty( this.sheetHeaderList ) ) {
			/** HEADER STYLE 조회 **/
			CellStyle  headerCellStyle = this.getHeaderCellStyle(workbook);
			Integer header_cell_index =  Integer.valueOf( this._column );

			for ( SheetHeader seetHeader : this.sheetHeaderList) {
				String headerName = seetHeader.getHeaderName();

				if( seetHeader.isHtml() ) {
					sheet.setColumnWidth(header_cell_index, 80*256 );
				}

				Cell cell = header_row.createCell( header_cell_index );
				cell.setCellStyle( headerCellStyle );
				this.setCellValue( cell, headerName );
				header_cell_index ++;


			}
		}

		/** BODY 생성 **/
		if( CollectionUtils.isNotEmpty( this.dataList ) ) {
			Integer body_row_index =  Integer.valueOf( this._rownum + 1 );

			/** 기본형 BODY CELL STYLE **/
			CellStyle  bodyCellStyle = this.getBodyCellStyle(workbook);

			/** HTML BODY CELL STYLE **/
			CellStyle htmlBodyCellStyle = this.getHtmlBodyCellStyle(workbook);


			for ( Map<String,Object> data : this.dataList ) {
				Row body_row = sheet.createRow( body_row_index  );
				Integer body_cell_index =  Integer.valueOf( this._column );

				for ( SheetHeader sheet_header : this.sheetHeaderList ) {
					String key = 	sheet_header.getHeaderKey();
					boolean is_html = sheet_header.isHtml();

					Object value = data.get( key );
					Cell body_cell = body_row.createCell( body_cell_index );

					if( is_html &&  value instanceof String  ) {



						body_cell.setCellStyle( htmlBodyCellStyle );
						String str_value = StringUtils.replace((String) value, "<br/>", "\n");
						this.setCellValue( body_cell , str_value );
					}else {
						body_cell.setCellStyle( bodyCellStyle );
						this.setCellValue( body_cell , value);
					}
					body_cell_index ++;
				}

				body_row_index ++;
			}
		}

		return sheet;
	}



	protected CellStyle getTitleStyle( Workbook workbook  ) {
		CellStyle  cellStyle = workbook.createCellStyle();
		cellStyle.setVerticalAlignment( VerticalAlignment.TOP );
		cellStyle.setAlignment( HorizontalAlignment.CENTER );
		return cellStyle;
	}

	protected CellStyle getNowTimeStyle( Workbook workbook  ) {
		CellStyle  cellStyle = workbook.createCellStyle();
		cellStyle.setAlignment( HorizontalAlignment.RIGHT );
		return cellStyle;
	}

	protected CellStyle getBodyCellStyle( Workbook workbook ) {
		CellStyle  bodyCellStyle = workbook.createCellStyle();
		bodyCellStyle.setVerticalAlignment( VerticalAlignment.TOP );
		bodyCellStyle.setAlignment( HorizontalAlignment.CENTER );

		bodyCellStyle.setBorderTop( BorderStyle.THIN );
		bodyCellStyle.setBorderBottom( BorderStyle.THIN );
		bodyCellStyle.setBorderLeft( BorderStyle.THIN );
		bodyCellStyle.setBorderRight( BorderStyle.THIN );

		return bodyCellStyle;
	}

	protected CellStyle getHtmlBodyCellStyle( Workbook workbook ) {
		CellStyle  bodyCellStyle = workbook.createCellStyle();

		bodyCellStyle.setWrapText( true );
		bodyCellStyle.setVerticalAlignment( VerticalAlignment.TOP );
		bodyCellStyle.setAlignment( HorizontalAlignment.LEFT );

		bodyCellStyle.setBorderTop( BorderStyle.THIN );
		bodyCellStyle.setBorderBottom( BorderStyle.THIN );
		bodyCellStyle.setBorderLeft( BorderStyle.THIN );
		bodyCellStyle.setBorderRight( BorderStyle.THIN );

		return bodyCellStyle;
	}


	protected CellStyle getHeaderCellStyle( Workbook workbook ) {
		CellStyle  headerCellStyle = workbook.createCellStyle();
		headerCellStyle.setFillForegroundColor( IndexedColors.YELLOW.getIndex() );
		headerCellStyle.setFillPattern( FillPatternType.SOLID_FOREGROUND );

		headerCellStyle.setVerticalAlignment( VerticalAlignment.TOP );
		headerCellStyle.setAlignment( HorizontalAlignment.CENTER );
		headerCellStyle.setBorderTop( BorderStyle.THIN );
		headerCellStyle.setBorderBottom( BorderStyle.THIN );
		headerCellStyle.setBorderLeft( BorderStyle.THIN );
		headerCellStyle.setBorderRight( BorderStyle.THIN );

		return headerCellStyle;
	}




	protected Object getCellValue( Cell cell )  {

		switch( cell.getCellTypeEnum() ) {
			case STRING:
				return cell.getStringCellValue();
			 case BOOLEAN:
				 return cell.getBooleanCellValue();
			 case NUMERIC:
				 if( DateUtil.isCellDateFormatted( cell )) {
					 return cell.getDateCellValue();
				 }
				 return cell.getNumericCellValue();
			 case FORMULA:
				 return cell.getCellFormula();
			 case BLANK:
				 return "";
			 default:
				 return "";
		}




	}


	/** CELL VALUE 세팅  **/
	protected void setCellValue( Cell cell , Object value ) {
		if( value == null ) {
			cell.setCellValue("");
		}else if( value instanceof String ) {
			cell.setCellValue( (String) value );
		}else if( value instanceof Boolean  ){
			cell.setCellValue( (Boolean) value );
		}else if( value instanceof Date ) {
			cell.setCellValue( (Date) value );
		}else if( value instanceof Double ) {
			cell.setCellValue( (Double) value );
		}else if( value instanceof Integer ){
			cell.setCellValue( Integer.toString( (Integer) value ) );
		}else if( value instanceof Long ) {
			cell.setCellValue( Long.toString( (Long) value ) );
		}else if(value instanceof BigDecimal) {
			cell.setCellValue( String.valueOf(value) );
		}else {
			cell.setCellValue( (String) value );
		}
	}
}
