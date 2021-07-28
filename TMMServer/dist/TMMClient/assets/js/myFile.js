function myMethod(id, scrollOffset) {
    console.log(id);
    if (id === '#home_p') {
        window.scrollTo(0, 0);
        return;
    }
    var p = document.querySelector(id);
    var position = p.offsetTop;
    position += scrollOffset;

    console.log(position);
    console.log(scrollOffset);
    window.scrollTo(0, position);

}