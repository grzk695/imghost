(function() {
  var Album, root;

  $(document).on("click", "#photo-selector-pagination a", function(e) {
    $.getScript(this.href);
    return false;
  });

  $(document).on("click", "#albums_adding a", function() {
    return window.album.read();
  });

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  Album = (function() {
    function Album() {
      this.data = [];
      this.id = "#image-selector";
      this.first = true;
    }

    Album.prototype.read = function() {
      var selected, unselected;
      selected = [];
      unselected = [];
      $(this.id + " option").each(function() {
        if ($(this).is(':selected')) {
          return selected.push($(this).val());
        } else {
          return unselected.push($(this).val());
        }
      });
      this.data = $(this.data).not(selected).get();
      this.data = this.data.concat(selected);
      return this.data = $(this.data).not(unselected).get();
    };

    Album.prototype.send = function(id) {
      this.read();
      return $.ajax({
        url: "/album/add/" + id,
        method: "POST",
        data: {
          _method: "PATCH",
          ids: this.data
        },
        dataType: 'script'
      });
    };

    return Album;

  })();

  if (!root.album) {
    root.album = new Album;
  }

}).call(this);
