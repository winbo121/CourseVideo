/*
 * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package egovframework.work.course.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter @ToString
public class KotechCourseModel {
	private String learn_time;
	private String course_seq;
	private String course_subject;
	private String course_nm;
	private String contents_nm;
	private String course_descr;
	private String course_persent;
	private String all_secound;
	private String all_secound_menu;
	private String watching_time;
	private String course_cnt;
	private String whatching_yn;
	private String user_id;
	private String contents_mapped_seq;
	private String contents_seq;
	private String star_point;
	private String user_name;
	private String role_type;
	
}
