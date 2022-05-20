// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require "zxcvbn.js"

$("#results").change(
    function() {
        console.log("Results changed....")
        var res_set = $(this).split(/\r?\n/);
        var res_out = [];
        console.log("set size: "+res_set.length)
        if( res_set.length > 0) {
            for(var i = 0; i < res_set.length; i++) {
                res_out = res_set[i]+" strength: "+zxcvbn(res_set[i]);
            }
            console.log("result out size: "+res_out.length)
            if (res_out.length > 0) {
                alert("Strengths:\n"+res_out.join("\n"));
            }
        }
    }
)