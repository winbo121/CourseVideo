<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>


 <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title">한모금 문장 추가</h4>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>




      <div class="modal-body">
        <div style="display: flex;">
          <select class="form-control controls width-auto fl mr5 fs-14">
            <option>작품 코드</option>
            <option>작품 명</option>
            <option>작가 명</option>
            <option>한모금 문장</option>
          </select>

          <input class="form-control controls width-auto fl fs-14 mr20" type="search" aria-label="Search" value="${adminId}">

          <div class="m-none" style="padding-top:48px;"></div> <!--mobile에서만 줄바뀜-->
          <button type="button" class="btn controls fl fs-14 width-auto bg-gradient-primary ht-38 mr10"><i class="fas fa-search"></i> 검색</button>

          <button type="button" class="btn controls fl fs-14 width-auto btn-outline-primary ht-38 mr10"><i class="fas fa-redo"></i> 초기화</button>
        </div>

              <div class="row">
                <div class="col-12">
                  <div class="card">
                    <!-- /.card-header -->
                    <div class="card-body table-responsive p-0" style="height: 350px;">
                      <table class="table table-head-fixed">
                        <colgroup>
                           <col width="15%">
                           <col width="30%">
                           <col width="10%">
                           <col width="*">
                        </colgroup>
                        <thead>
                          <tr>
                            <th>작품코드</th>
                            <th>작품 명</th>
                            <th>작가 명</th>
                            <th>하이라이트 문장</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr>
                            <td>A12345678</td>
                            <td>행복해지는 연습을 해요 작품명입니다리미</td>
                            <td>감수광</td>
                            <td>Bacon ipsum dolor sit amet salami venison chicken flank fatback doner.Bacon ipsum dolor sit amet salami venison chicken flank fatback doner.</td>
                          </tr>
                          <tr>
                            <td>A12345678</td>
                            <td>행복해지는 연습을 해요 작품명입니다리미</td>
                            <td>감수광</td>
                            <td>Bacon ipsum dolor sit amet salami venison chicken flank fatback doner.Bacon ipsum dolor sit amet salami venison chicken flank fatback doner.</td>
                          </tr>
                          <tr>
                            <td>A12345678</td>
                            <td>행복해지는 연습을 해요 작품명입니다리미</td>
                            <td>감수광</td>
                            <td>Bacon ipsum dolor sit amet salami venison chicken flank fatback doner.Bacon ipsum dolor sit amet salami venison chicken flank fatback doner.</td>
                          </tr>
                          <tr>
                            <td>A12345678</td>
                            <td>행복해지는 연습을 해요 작품명입니다리미</td>
                            <td>감수광</td>
                            <td>Bacon ipsum dolor sit amet salami venison chicken flank fatback doner.Bacon ipsum dolor sit amet salami venison chicken flank fatback doner.</td>
                          </tr>
                          <tr>
                            <td>A12345678</td>
                            <td>행복해지는 연습을 해요 작품명입니다리미</td>
                            <td>감수광</td>
                            <td>Bacon ipsum dolor sit amet salami venison chicken flank fatback doner.Bacon ipsum dolor sit amet salami venison chicken flank fatback doner.</td>
                          </tr>
                          <tr>
                            <td>A12345678</td>
                            <td>행복해지는 연습을 해요 작품명입니다리미</td>
                            <td>감수광</td>
                            <td>Bacon ipsum dolor sit amet salami venison chicken flank fatback doner.Bacon ipsum dolor sit amet salami venison chicken flank fatback doner.</td>
                          </tr>
                          <tr>
                            <td>A12345678</td>
                            <td>행복해지는 연습을 해요 작품명입니다리미</td>
                            <td>감수광</td>
                            <td>Bacon ipsum dolor sit amet salami venison chicken flank fatback doner.Bacon ipsum dolor sit amet salami venison chicken flank fatback doner.</td>
                          </tr>
                          <tr>
                            <td>A12345678</td>
                            <td>행복해지는 연습을 해요 작품명입니다리미</td>
                            <td>감수광</td>
                            <td>Bacon ipsum dolor sit amet salami venison chicken flank fatback doner.Bacon ipsum dolor sit amet salami venison chicken flank fatback doner.</td>
                          </tr>
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
              <nav style="text-align: center;">
                  <ul class="pagination" style="display: inline-flex;">
                      <li>
                          <select class="form-control controls width-auto fs-14 ht-36 mo-none">
                            <option>10</option>
                            <option>15</option>
                            <option>20</option>
                            <option>30</option>
                            <option>50</option>
                            <option>100</option>
                          </select>
                      </li>
                      <li class="page-item disabled"><span class="page-link">&lt;&lt;</span></li>
                      <li class="page-item disabled"><span class="page-link">&lt;</span></li>
                      <li class="page-item active"><a href="#" class="page-link">1</a></li>
                      <li class="page-item"><a href="#" class="page-link">2</a></li>
                      <li class="page-item"><a href="#" class="page-link">3</a></li>
                      <li class="page-item"><a href="#" class="page-link">4</a></li>
                      <li class="page-item"><a href="#" class="page-link">5</a></li>
                      <li class="page-item"><a href="#" class="page-link">&gt;</a></li>
                      <li class="page-item"><a href="#" class="page-link">&gt;&gt;</a></li>
                  </ul>
              </nav>

      </div>
      <div class="modal-footer justify-content-between">
        <button type="button" class="btn btn-default toastrDefaultSuccess" data-dismiss="modal">취소</button>
        <button type="button" class="btn btn-primary" onclick="${modal_id}_pop_test();">다음</button>
      </div>
    </div>
    <!-- /.modal-content -->
 </div>



