
$(document).ready(function(){

    $('.selectpicker').selectpicker();    

    val = $('.selectpicker option:selected').val();
    $('.font-icon-detail span:first-child').css( "font-size", val + "px" );
    $('#content').removeClass().addClass("size"+val);

    $('.selectpicker').change(function(){
        val = $('.selectpicker option:selected').val();
        $('.font-icon-detail span:first-child').css( "font-size", val + "px" );
        $('#content').removeClass().addClass("size"+val);
    });

    $('#chkbx-1').change(function() {
       if($(this).is(":checked")) {
            $('.font-icon-code').addClass('show');
          return;
       }
        $('.font-icon-code').removeClass('show');
    });

    $('#s1').change(function() {
       if($(this).is(":checked")) {
          $('body').addClass("dark");
          return;
       }
      $('body').removeClass("dark");
    });

    $('#nav').affix({
        offset: { top: $('#nav').offset().top },
    });

    $('#nav').on('affix.bs.affix', function () {
        $('#font_options_bar').height($("#nav").height());
    });

    $('#nav').on('affixed-top.bs.affix', function () {
        $('#font_options_bar').height('auto');
    });

    $(".code-value, .unicode, .unicode-text, .font-icon-name").click(function(){
      $(this).select();
    });

    $('.font-icon-detail').on("click", function(){
      $(this).find('.font-icon-name').select();
    });


    searchShow.onchange = function(){
      if(this.checked) {
        setTimeout(function(){
          search.focus()  
        },50)
      }
    }

    search.onchange = function(){
      doSearch(this.value);
    }
    search.onkeyup = function(e){
      if (e.keyCode == 27) {
        this.value = "";
        searchShow.checked = false;
        window.location.search = '';
      } else if (e.keyCode == 13) {
        window.location.search = 'search=' + this.value;
      }
      doSearch(this.value);
    }

    if(getQueryVariable('search')){
      doSearch(getQueryVariable('search'));
      search.value = getQueryVariable('search');
    }

    search.focus();


}) // Ready


$(window).scroll(function() {
  var opacityValue;
  opacityValue = 1 - $(window).scrollTop() / 315;
  return $("#showcase hgroup").css("opacity", opacityValue);
});

var search = document.querySelector('#search');
var searchShow = document.querySelector('#search-show');
var emptySearch = document.querySelector('#search-empty');


function doSearch(filter){
    // var filter = filter.value;
    var allIcons = document.getElementById('all-icons');
    var all = allIcons.querySelectorAll('.font-icon-list');
    var contains = allIcons.querySelectorAll('.font-icon-name[value*="' + filter + '"]');
    

    var cont = allIcons.querySelectorAll('.row .font-icon-name[value*="' + filter + '"]'); // with Titles only
    var titles = allIcons.querySelectorAll('.subtitle'); // with Titles only

    for (var i = 0; i < titles.length; i++) {
        titles[i].style.display = "block";
    }; // with Titles only

    if(filter != "") {
      for (var i = 0; i < all.length; i++) {
        all[i].style.display = "none";
      };

      for (var i = 0; i < titles.length; i++) {
        titles[i].style.display = "none";
      }

      for (var i = 0; i < contains.length; i++) {
        contains[i].parentElement.parentElement.style.display = "block";
        contains[i].parentElement.parentElement.parentElement.previousSibling.previousSibling.style.display = "block"; // lol // with Titles only
      };

      if(contains.length == 0){
        emptySearch.style.display = "block";
        emptySearch.querySelector('strong').innerHTML = search.value;
      } else {
        emptySearch.style.display = "none";
      }
    } else {
      for (var i = 0; i < all.length; i++) {
        all[i].style.display = "block";
      };
      emptySearch.style.display = "none";
    }


}



function getQueryVariable(variable) {
  var query = window.location.search.substring(1);
  var vars = query.split("&");
  for (var i=0;i<vars.length;i++) {
    var pair = vars[i].split("=");
    if(pair[0] == variable){return pair[1];}
  }
  return(false);
}


