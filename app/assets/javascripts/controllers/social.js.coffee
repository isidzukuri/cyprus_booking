window.social_login_initialised = false
window.social_login_callbacks = (response) ->
  if response.success
    window.location.reload()

window.init_social_login = ->
  if not window.social_login_initialised and typeof (FB) isnt "undefined"
    FB.init
      appId: FBappId #Initialize it in HTML please
      status: true
      cookie: true
      xfbml: true

    window.social_login_initialised = true

window.doFbLogin = ->
  FB.login ((response) ->
    if response.status is "connected"
      $.ajax
        type: "POST"
        url: "/user/fbregister/"
        dataType: "json"
        data:
          access_token: response.authResponse.accessToken
          uid: response.authResponse.userID

        success: (msg) ->
          window.social_login_callbacks msg

    else
      
      # user cancelled login
      console.log response
      alert "login canceled"
  ),
    scope: "email,user_birthday,user_hometown,user_location,user_website"


$(document).ready ->
  window.init_social_login()
