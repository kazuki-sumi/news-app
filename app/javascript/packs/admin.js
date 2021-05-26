import '../src/admin/style.scss';
import JQuery from 'jquery';
import select2 from 'select2/dist/js/select2.full.min';

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

require("@coreui/coreui")

$(function() {
  $('.js-category').select2({
    width: '100%'
  });
});