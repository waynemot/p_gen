# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
#= require "zxcvbn.js"
$ ->

  update_results = ->
          console.log("Results changed....")
          res_set = $(this).val().split("\n");
          res_out = [];
          console.log("set size: "+res_set.length)
          if( res_set.length > 0)
              #for (i = 0; i < res_set.length; i++)
            for res_val in res_set
              zxc_res = zxcvbn(res_val)
              res_out += res_val + " strength: " + zxc_res["crack_times_display"]['online_throttling_100_per_hour'] + "<br/>";

            #console.log("result out size: " + res_out.length)
            if (res_out.length > 0)
              alert("Strengths:\n" + res_out)
              $("#strengths").html("<%= res_out %>")
          console.log("set submit data-transitioning=false.... ")
          $("input.btn").on(":hover").fadeOut()
  #
  #
test_pw =() ->
  pw = $("input#pw_test_input").val()
  alert(pw)
