<%--TODO: 1. Sorting and pagination over registered stores --%>
<%--TODO: 2. Store detail modification page --%>
<%--TODO: 3. Socials drop and replace with another content --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>Application</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.6.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<%@ include file="../../common/navbar.jsp" %>
<div class="container">
    <div class="row my-5">
        <div class="col-md-5 my-5">
            <div class="position-sticky" style="top: 5rem;">
                <div class="card shadow-sm border border-0 my-3">
                    <div class="fw-lighter m-3 p-1">
                        <div class="row">
                            <div class="col-8 fs-4">About Me</div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row mx-2">
                            <div class="col-sm-4 my-1 fw-lighter">
                                <label for="fullName" class="col-sm-2 col-form-label"><span style="white-space: nowrap">Full Name</span></label>
                            </div>
                            <div class="col-sm-8 my-1">
                                <p class="form-control-plaintext" id="fullName"> ${ owner.fullName } </p>
                            </div>
                        </div>
                        <div class="row mx-2">
                            <div class="col-sm-4 my-1 fw-lighter">
                                <label for="nickName" class="col-sm-2 col-form-label"><span style="white-space: nowrap">Nickname</span></label>
                            </div>
                            <div class="col-sm-8 my-1">
                                <p class="form-control-plaintext" id="nickName"> ${ owner.nickname } </p>
                            </div>
                        </div>
                        <div class="row mx-2">
                            <div class="col-sm-4 my-1 fw-lighter">
                                <label for="email" class="col-sm-2 col-form-label"><span
                                        style="white-space: nowrap">Email</span></label>
                            </div>
                            <div class="col-sm-8 my-1">
                                <p class="form-control-plaintext" id="email"> ${ owner.email } </p>
                            </div>
                        </div>
                    </div>
                </div>
                <span class="fw-li"></span>
                <div class="card shadow-sm border border-0">
                    <div class="fw-lighter m-3 p-1">
                        <div class="row align-items-center">
                            <div class="col fs-4">
                                Some components..
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-7 my-5">
            <div class="fw-lighter m-3 p-1">
                <div class="row">
                    <div class="col-4 fs-4">My Stores</div>
                    <div class="col-8 d-flex justify-content-end">
                        <div class="pb-2 my-1 border-bottom text-end">
                                <span class="badge bg-primary-subtle border border-primary-subtle text-primary-emphasis rounded-pill my-2"
                                      type="button"
                                      onclick="window.location.href=`/owner/register`">
                                    Add your store!
                                </span>
                            <span id="storesButton"
                                  type="button"
                                  class="badge bg-success-subtle border border-success-subtle text-success-emphasis rounded-pill mx-1">
                                    My stores
                                </span>
                            <span id="reviewsButton"
                                  type="button"
                                  class="badge bg-warning-subtle border border-warning-subtle text-warning-emphasis rounded-pill mx-1">
                                    Reviews
                                </span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div id="contentOutputArea">
                </div>
                <div class="text-center">
                    <div class="btn border border-0 disabled">
                        <div id="storeLoadingSpinner"
                             class="spinner-border spinner-border-sm text-primary m-1" role="status"
                             style="display: none;">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="toast-container position-fixed bottom-0 end-0 p-4">
        <div id="successfulToast" class="toast text-bg-primary" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto"
                        data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    </div>
</div>
</body>
<script>

    const storeLoadingSpinner = document.getElementById('storeLoadingSpinner')
    const contentOutputArea = document.getElementById('contentOutputArea')

    let pageOnStore = 0;
    let isStoreFetching = false;
    let isStoreLast = false;

    let currentFetchingOption = null;

    const getStores = page => {
        return fetch(`/owner/stores?page=\${page}&limit=3`).then(response => response.json());
    }

    function fetchAndRenderStores(page) {
        isStoreFetching = true
        storeLoadingSpinner.style.display = 'block';

        getStores(page).then(data => {

            if (data.last) {
                isStoreLast = true;
                storeLoadingSpinner.style.display = 'none'
            }

            data.forEach(datum => {

                function removeSecondsFromTime(timeString) {
                    return timeString.split(':').slice(0, 2).join(':');
                }

                let foodBadges = '';
                datum.foods.forEach(food => {
                    const foodBadge = `
                        <span class="badge bg-light-subtle border border-light-subtle text-light-emphasis rounded-pill mx-1">
                            \${food.name}
                        </span>
                    `;
                    foodBadges += foodBadge;
                });

                let openTimesBadges = '';
                datum.openTimes.forEach(openTime => {
                    const openTimesBadge = `
                        <span class="badge bg-light-subtle border border-light-subtle text-light-emphasis rounded-pill position-relative mx-4 my-2">
                            \${openTime.day}
                            <span class="position-absolute top-100 start-100 translate-middle badge rounded-pill bg-secondary-subtle text-secondary my-1">
                                \${removeSecondsFromTime(openTime.openTime)} ~ \${removeSecondsFromTime(openTime.closeTime)}
                            </span>
                        </span>
                    `
                    openTimesBadges += openTimesBadge;
                })

                let wishersBadges = '';
                datum.wishers.forEach(wisher => {
                    const wishersBadge = `
                        <span type="button"
                              class="badge bg-warning-subtle border border-warning-subtle text-warning-emphasis rounded-pill my-2 userDetailEntry"
                              data-user-id=\${wisher.id}>
                            \${wisher.nickname}
                        </span>
                    `
                    wishersBadges += wishersBadge;
                })

                contentOutputArea.innerHTML += `
                        <div class="bg-light rounded-3 p-3 my-4 shadow-sm">
                            <div class="row d-flex align-items-center justify-content-center">
                                <div class="col-lg-10">
                                    <span type="button" class="fs-3 fw-lighter storeDetailsEntry" data-store-id="\${datum.store.id}">
                                        \${datum.store.name}
                                    </span>
                                    <span class="badge bg-light-subtle border border-light-subtle text-light-emphasis rounded-pill ">
                                        \${datum.store.address}
                                    </span>
                                </div>
                                <div class="col-lg-2">
                                    <div class="text-end">
                                        <span class="badge bg-secondary-subtle border border-secondary-subtle text-secondary-emphasis rounded-pill mx-1">
                                            \${datum.store.category}
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="fw-light shadow-sm rounded-2 bg-white my-3 p-4 overflow-auto">
                                \${datum.store.description}
                            </div>
                            <div class="my-4 px-4">
                                \${foodBadges}
                            </div>
                            <div class="my-3">
                                \${openTimesBadges}
                            </div>
                            <div class="m-4 pt-3">
                                <span class="fw-lighter fs-6">Bookmarked by..</span>
                                <div class="border-top">
                                    \${wishersBadges}
                                </div>
                            </div>
                        </div>
                `
                isStoreFetching = true;
                storeLoadingSpinner.style.display = 'none';
            })
        })
    }

    // initial loading
    fetchAndRenderStores(pageOnStore);
    currentFetchingOption = (page) => {
        return fetchAndRenderStores(page)
    }

    document.getElementById('storesButton').addEventListener('click', function () {

        contentOutputArea.innerHTML = '';

        pageOnStore = 0;
        isStoreFetching = false;
        isStoreLast = false;

        fetchAndRenderStores(pageOnStore);
        currentFetchingOption = (page) => {
            return fetchAndRenderStores(page)
        }
    })

    addEventListener('click', function(event) {
        if (event.target.classList.contains('storeDetailsEntry')) {
            const button = event.target;
            const storeId = button.getAttribute('data-store-id')

            window.location.href = `/store/detail?id=\${storeId}`
        }
    })

    addEventListener('click', function (event) {
        if (event.target.classList.contains('userDetailEntry')) {
            const button = event.target;
            const userId = button.getAttribute('data-user-id')

            window.location.href = `/customer/user-details?id=\${userId}`
        }
    })

    window.onscroll = function () {

        if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight + 96) {

            if (isStoreFetching || isStoreLast) {
                // do nothing
            } else {
                pageOnPictureData += 1;
                currentFetchingOption(pageOnPictureData);
            }
        }
    }


    const params = new URLSearchParams(window.location.search);

    // window.location.href = "/owner/my-page?registration=success"
    if (params.get("registration") === "success") {
        showMessagingToast("Successfully registered :)");
    }

    function showMessagingToast(message) {
        const successfulToast = document.getElementById('successfulToast');
        const toastBody = successfulToast.querySelector('.toast-body');

        toastBody.textContent = message;

        const successfulToastBootstrap = bootstrap.Toast.getOrCreateInstance(successfulToast);
        successfulToastBootstrap.show();
    }
</script>
</html>
