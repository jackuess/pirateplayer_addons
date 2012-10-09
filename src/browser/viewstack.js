.pragma library

var currentFactory;
var factoryStack = [];

function pushFactory(newFactory) {
    currentFactory.scroll = scrollArea.verticalScrollBar.value;
    factoryStack.push(currentFactory);
    currentFactory = newFactory;
    currentFactory.callback();
}

var scrollArea;
function setScrollArea(area) {
    scrollArea = area;
}
