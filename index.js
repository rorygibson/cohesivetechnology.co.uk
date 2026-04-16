$(document).ready(function() {
    // Smooth scrolling for anchor links
    $('a[href^="#"]').on('click', function(event) {
        var target = $(this.getAttribute('href'));
        if(target.length) {
            event.preventDefault();
            $('html, body').stop().animate({
                scrollTop: target.offset().top - 70
            }, 1000);
        }
    });

    // Active nav link highlighting
    var currentPage = window.location.pathname.split('/').pop() || 'index.html';
    $('.nav-link').each(function() {
        var linkPage = $(this).attr('href');
        if(linkPage === currentPage) {
            $(this).addClass('active');
        } else {
            $(this).removeClass('active');
        }
    });

    // Add animation on scroll for service cards
    $(window).scroll(function() {
        $('.service-card').each(function() {
            var position = $(this).offset().top;
            var scrollTop = $(window).scrollTop();
            var windowHeight = $(window).height();
            if (scrollTop + windowHeight > position + 100) {
                $(this).css('opacity', '1');
            }
        });
    });
});
