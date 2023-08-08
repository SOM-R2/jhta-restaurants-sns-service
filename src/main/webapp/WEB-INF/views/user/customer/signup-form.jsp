<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<%@ include file="../../common/navbar.jsp" %>
<div class="container">
    <div class="row my-2 justify-content-center align-items-center">
        <div class="col-md-6">
            <div class="card shadow my-5">
                <div class="fw-light text-center my-3">손님 회원 가입</div>
                <div class="card-body">
                    <div class="row my-1 p-1">
                        <form method="post" action="signup" modelAttribute="userCommand">
                            <div class="form-floating my-3">
                                <input type="text" class="form-control" name="username" id="username" placeholder=""/>
                                <label class="fw-lighter" for="username">유저 아이디</label>
                            </div>
                            <div class="form-floating my-3">
                                <input type="password" class="form-control" name="password" id="password" placeholder=""/>
                                <label class="fw-lighter" for="password">비밀번호</label>
                            </div>
                            <div class="form-floating my-3">
                                <input type="text" class="form-control" name="fullName" id="fullName" placeholder=""/>
                                <label class="fw-lighter" for="fullName">성함</label>
                            </div>
                            <div class="form-floating my-3">
                                <input type="email" class="form-control" name="email" id="email" placeholder=""/>
                                <label class="fw-lighter" for="email">이메일</label>
                            </div>
                            <div class="form-floating my-3">
                                <input type="text" class="form-control" name="phone" id="phone" placeholder=""/>
                                <label class="fw-lighter" for="phone">전화번호</label>
                            </div>
                            <div class="form-group my-3">
                                <div class="row">
                                    <div class="col">
                                        <div class="row">
                                            <div class="col-8">
                                                <input type="date" class="form-control fw-lighter" name="birthday"/>
                                            </div>
                                            <div class="col-4">
                                                <select class="form-select fw-lighter" name="gender">
                                                    <option value="">성별</option>
                                                    <option value="male">남</option>
                                                    <option value="female">여</option>
                                                    <option value="other">그 외</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="text-end my-2">
                                <button id="signupButton"
                                        class="btn btn-outline-secondary btn-sm"
                                        data-bs-toggle="collapse"
                                        data-bs-target="#otpCollapse"
                                        aria-expanded="false"
                                        aria-controls="otpCollapse"
                                        disabled
                                >
                                    OTP
                                </button>
                            </div>
                            <div class="toast-container position-fixed bottom-0 end-0 p-4">
                                <div id="successfulToast" class="toast align-items-center text-bg-primary border-0" role="alert"
                                     aria-live="assertive" aria-atomic="true">
                                    <div class="d-flex">
                                        <div class="toast-body">
                                            OTP가 발송되었습니다. 이메일을 확인해주세요 :)
                                        </div>
                                        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                                    </div>
                                </div>
                            </div>
                            <div class="toast-container position-fixed bottom-0 end-0 p-4">
                                <div id="failedToast" class="toast align-items-center text-bg-secondary border-0" role="alert"
                                     aria-live="assertive" aria-atomic="true">
                                    <div class="d-flex">
                                        <div class="toast-body">
                                            OTP 발송 중 문제가 생겼습니다. 다시 한 번 시도해주세요.
                                        </div>
                                        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                                    </div>
                                </div>
                            </div>
                            <%--                            TODO: OTP validation --%>
                            <div class="collapse mt-3" id="otpCollapse">
                                <div class="card card-body">
                                    <label class="fw-lighter" for="otp">OTP</label>
                                    <div class="row">
                                        <div class="input-group">
                                            <div class="col-11">
                                                <input class="form-control-plaintext" id="otp" name="otp">
                                            </div>
                                            <div class="col-1 d-flex justify-content-center align-items-center">
                                            <span class="">
                                                <i class="bi bi-send" onclick="otpValidationRequest()"></i>
                                            </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const signupButton = document.getElementById("signupButton");

        const usernameInput = document.querySelector('input[name="username"]');
        const passwordInput = document.querySelector('input[name="password"]');
        const fullNameInput = document.querySelector('input[name="fullName"]');
        const emailInput = document.querySelector('input[name="email"]');
        const phoneInput = document.querySelector('input[name="phone"]');
        const birthdayInput = document.querySelector('input[name="birthday"]');
        const genderInput = document.querySelector('select[name="gender"]');

        let validationStatus = { // default to false
            usernameInput: false,
            passwordInput: false,
            fullNameInput: false,
            emailInput: false,
            phoneInput: false,
            birthdayInput: false,
            genderInput: false
        }

        function updateSubmitButton() {
            const submitButton = document.getElementById("signupButton");
            if (Object.values(validationStatus).every(status => status === true)) {
                submitButton.removeAttribute("disabled");
            } else {
                submitButton.setAttribute("disabled", "disabled");
            }
        }

        function displayErrorMessage(input, message) {

            input.classList.add('is-invalid');

            const errorDiv = document.createElement('div');
            errorDiv.className = 'invalid-feedback';
            errorDiv.textContent = message;

            const parentDiv = input.parentElement;
            parentDiv.appendChild(errorDiv);
        }

        function removeErrorMessage(input) {

            input.classList.remove('is-invalid');

            const parentDiv = input.parentElement;
            const errorDiv = parentDiv.querySelector('.invalid-feedback');
            if (errorDiv) {
                parentDiv.removeChild(errorDiv);
            }
        }

        function displaySuccessMessage(input) {
            input.classList.add("is-valid");
        }

        function removeSuccessMessage(input) {
            input.classList.remove("is-valid");
        }

        usernameInput.addEventListener("blur", function () {
            removeErrorMessage(this);
            if (this.value.trim() === '') {
                displayErrorMessage(this, "필수 입력 사항입니다.");
                validationStatus.usernameInput = false;
            } else {
                removeSuccessMessage(this);
                displaySuccessMessage(this);

                validationStatus.usernameInput = true;
            }
            updateSubmitButton();
        });

        passwordInput.addEventListener("blur", function () {
            removeErrorMessage(this);
            if (this.value.trim() === '') {
                displayErrorMessage(this, "필수 입력 사항입니다.");
                validationStatus.passwordInput = false;
            } else {
                removeSuccessMessage(this);
                displaySuccessMessage(this);

                validationStatus.passwordInput = true;
            }
            updateSubmitButton();
        });

        fullNameInput.addEventListener("blur", function () {
            const koreanNamePattern = /^[가-힣]{2,5}$/;

            removeErrorMessage(this);
            if (this.value.trim() === '') {
                displayErrorMessage(this, "필수 입력 사항입니다.")
                validationStatus.fullNameInput = false;
            } else if (!koreanNamePattern.test(this.value.trim())) {
                displayErrorMessage(this, "올바른 형식의 성함을 적어주세요.");
                validationStatus.fullNameInput = false;
            } else {
                removeSuccessMessage(this);
                displaySuccessMessage(this);

                validationStatus.fullNameInput = true;
            }
            updateSubmitButton();
        })

        // TODO: DB constraint (unique) validation via ajax
        emailInput.addEventListener("blur", function () {
            removeErrorMessage(this);
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(this.value.trim())) {
                displayErrorMessage(this, "올바른 형식의 이메일을 적어주세요.");
                validationStatus.emailInput = false;
            } else {
                removeSuccessMessage(this);
                displaySuccessMessage(this);

                validationStatus.emailInput = true;
            }
            updateSubmitButton();
        });

        // TODO: DB constraint (unique) validation via ajax
        phoneInput.addEventListener("blur", function () {
            const phonePattern = /^010-[0-9]{4}-[0-9]{4}$/;

            removeErrorMessage(this);
            if (this.value.trim() === '') {
                displayErrorMessage(this, "필수 입력 사항입니다.");
                validationStatus.phoneInput = false;
            } else if (!phonePattern.test(this.value.trim())) {
                displayErrorMessage(this, "올바른 형식의 전화번호를 적어주세요.");
                validationStatus.phoneInput = false;
            } else {
                removeSuccessMessage(this);
                displaySuccessMessage(this);

                validationStatus.phoneInput = true;
            }
            updateSubmitButton();
        });

        birthdayInput.addEventListener("blur", function () {
            removeErrorMessage(this);
            if (this.value.trim() === '') {
                displayErrorMessage(this, "필수 입력 사항입니다.");
                validationStatus.birthdayInput = false;
            } else {
                removeSuccessMessage(this);
                displaySuccessMessage(this);

                validationStatus.birthdayInput = true;
            }
            updateSubmitButton();
        });

        genderInput.addEventListener("blur", function () {
            removeErrorMessage(this);
            if (this.value === '') {
                displayErrorMessage(this, "성별을 선택해주세요.");
                validationStatus.genderInput = false;
            } else {
                removeSuccessMessage(this);
                displaySuccessMessage(this);

                validationStatus.genderInput = true;
            }
            updateSubmitButton();
        });

        signupButton.addEventListener("click", function (event) {
            event.preventDefault();
            const errorMessages = document.querySelectorAll('.invalid-feedback');

            if (Object.values(validationStatus).some(status => status === false)) {
                // do nothing

            } else if (errorMessages.length > 0) {
                // do nothing

            } else {
                const formData = {
                    username: usernameInput.value.trim(),
                    password: passwordInput.value.trim(),
                    fullName: fullNameInput.value.trim(),
                    email: emailInput.value.trim(),
                    phone: phoneInput.value.trim(),
                    birthday: birthdayInput.value,
                    gender: genderInput.value
                };

                fetch("/customer/signup", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify(formData)
                })
                    .then(response => {
                        if (response.ok) {

                            const email = encodeURIComponent(formData.email);

                            fetch(`/customer/otp?email=\${email}`, {
                                method: "GET"
                            }).then(response => {
                                if (response.ok) {

                                    // show successful message in toast
                                    let successfulToast = document.getElementById('successfulToast')
                                    const toastSentBootstrap = bootstrap.Toast.getOrCreateInstance(successfulToast)
                                    toastSentBootstrap.show()
                                } else {

                                    // show failed message in toast
                                    let failedToast = document.getElementById('failedToast')
                                    const toastSentBootstrap = bootstrap.Toast.getOrCreateInstance(failedToast)
                                    toastSentBootstrap.show()
                                }
                            });
                        } else {
                            // TODO: handle signup errors
                        }
                    })
            }
        });
    });

    function otpValidationRequest() {
        const email = document.querySelector('input[name="email"]').value.trim();
        const otpCode = document.querySelector('#otp').value

        const formData = {
            email: email,
            otpCode: otpCode
        }

        fetch(`/customer/otp-check`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(formData)
        }).then(response => {
            if (response.ok) {
                window.location.href = "/user/login"
            } else {
                // TODO: handle errors on bad credentials
            }
        })
    }
</script>
</body>
</html>