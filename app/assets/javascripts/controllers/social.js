window.social_login_initialised = false;

window.social_login_callbacks = function(response) {
  if (response.success) {
    return window.location.reload();
  }
};

window.init_social_login = function() {
  console.log(FBappId)
  if (!window.social_login_initialised && typeof FB !== "undefined") {
    FB.init({
      appId: FBappId,
      status: true,
      cookie: true,
      xfbml: true
    });
    return window.social_login_initialised = true;
  }
};

window.doFbLogin = function() {
  return FB.login((function(response) {
    if (response.status === "connected") {
      return $.ajax({
        type: "get",
        url: "/fbregister/",
        dataType: "json",
        data: {
          access_token: response.authResponse.accessToken,
          uid: response.authResponse.userID
        },
        success: function(msg) {
          return window.social_login_callbacks(msg);
        }
      });
    } else {
      console.log(response);
      return alert("login canceled");
    }
  }), {
    scope: "email,user_birthday,user_hometown,user_location,user_website"
  });
};

$(document).ready(function() {
  return window.init_social_login();
});
