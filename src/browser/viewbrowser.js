.pragma library

var currentView;
var viewStack = [];
var loader;

function loadView(url, args, silent) {
    if (currentView && !silent)
        viewStack.push(currentView);

    currentView = { url: url, args: args };
    loader.source = currentView.url;
}

function goBack() {
    if (viewStack.length > 0) {
        currentView = viewStack.pop();
        loader.source = currentView.url;
    }
}

function setLoader(newLoader) {
    loader = newLoader;
}

var mainWindow;
function setMainWindow(window) {
    mainWindow = window;
}

function piratePlay(url, metaData) {
    mainWindow.getStreams( url,
                          metaData );
}
