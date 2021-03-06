#' @export xplit
#' @export sentence2table
#' @export table2gset
#' @export co_occurence
#' @export get_sentences
#' @export build_graph
#' @export summarize
#' @import KoNLP
#' @import igraph
#' @import stringi
#' @importFrom sets gset
#' @importFrom utils capture.output combn

.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Rtextrankr 1.0.0")
}

#' Separate text into sentence list by delimiter.
#' Example will be shown in \href{https://github.com/mikigom/Rtextrankr}{github}.
#'
#' @param text The long character string including delimiter([.|!|?|blank line]).
#' @return The list of character string seperated by delimiter.
xplit <- function(text) {
  return(unlist(strsplit(text, "[.|!|?|\n|.\n]")))
}

#' Convert sentence to noun word table except stopword.
#' Example will be shown in \href{https://github.com/mikigom/Rtextrankr}{github}.
#'
#' @param sentence The character string.
#' @return A table which refers noun word frequency, except Korean stopword.
sentence2table <- function(sentence) {
  stopwords <- c("\uc544","\ud734","\uc544\uc774\uad6c",
                 "\uc544\uc774\ucfe0","\uc544\uc774\uace0","\uc5b4",
                 "\ub098","\uc6b0\ub9ac","\uc800\ud76c",
                 "\ub530\ub77c","\uc758\ud574","\uc744",
                 "\ub97c","\uc5d0","\uc758",
                 "\uac00","\uc73c\ub85c","\ub85c",
                 "\uc5d0\uac8c","\ubfd0\uc774\ub2e4","\uc758\uac70\ud558\uc5ec",
                 "\uadfc\uac70\ud558\uc5ec","\uc785\uac01\ud558\uc5ec","\uae30\uc900\uc73c\ub85c",
                 "\uc608\ud558\uba74","\uc608\ub97c","\ub4e4\uba74",
                 "\ub4e4\uc790\uba74","\uc800","\uc18c\uc778",
                 "\uc18c\uc0dd","\uc800\ud76c","\uc9c0\ub9d0\uace0",
                 "\ud558\uc9c0\ub9c8","\ud558\uc9c0\ub9c8\ub77c","\ub2e4\ub978",
                 "\ubb3c\ub860","\ub610\ud55c","\uadf8\ub9ac\uace0",
                 "\ube44\uae38\uc218","\uc5c6\ub2e4","\ud574\uc11c\ub294",
                 "\uc548\ub41c\ub2e4","\ubfd0\ub9cc","\uc544\ub2c8\ub77c",
                 "\ub9cc\uc774","\uc544\ub2c8\ub2e4","\ub9cc\uc740",
                 "\uc544\ub2c8\ub2e4","\ub9c9\ub860\ud558\uace0","\uad00\uacc4\uc5c6\uc774",
                 "\uadf8\uce58\uc9c0","\uc54a\ub2e4","\uadf8\ub7ec\ub098",
                 "\uadf8\ub7f0\ub370","\ud558\uc9c0\ub9cc","\ub4e0\uac04\uc5d0",
                 "\ub17c\ud558\uc9c0","\uc54a\ub2e4","\ub530\uc9c0\uc9c0",
                 "\uc54a\ub2e4","\uc124\uc0ac","\ube44\ub85d",
                 "\ub354\ub77c\ub3c4","\uc544\ub2c8\uba74","\ub9cc",
                 "\ubabb\ud558\ub2e4","\ud558\ub294","\ud3b8\uc774",
                 "\ub0ab\ub2e4","\ubd88\ubb38\ud558\uace0","\ud5a5\ud558\uc5ec",
                 "\ud5a5\ud574\uc11c","\ud5a5\ud558\ub2e4","\ucabd\uc73c\ub85c",
                 "\ud2c8\ud0c0","\uc774\uc6a9\ud558\uc5ec","\ud0c0\ub2e4",
                 "\uc624\ub974\ub2e4","\uc81c\uc678\ud558\uace0","\uc774",
                 "\uc678\uc5d0","\uc774","\ubc16\uc5d0",
                 "\ud558\uc5ec\uc57c","\ube44\ub85c\uc18c","\ud55c\ub2e4\uba74",
                 "\ubab0\ub77c\ub3c4","\uc678\uc5d0\ub3c4","\uc774\uacf3",
                 "\uc5ec\uae30","\ubd80\ud130","\uae30\uc810\uc73c\ub85c",
                 "\ub530\ub77c\uc11c","\ud560","\uc0dd\uac01\uc774\ub2e4",
                 "\ud558\ub824\uace0\ud558\ub2e4","\uc774\ub9ac\ud558\uc5ec","\uadf8\ub9ac\ud558\uc5ec",
                 "\uadf8\ub807\uac8c","\ud568\uc73c\ub85c\uc368","\ud558\uc9c0\ub9cc",
                 "\uc77c\ub54c","\ud560\ub54c","\uc55e\uc5d0\uc11c",
                 "\uc911\uc5d0\uc11c","\ubcf4\ub294\ub370\uc11c","\uc73c\ub85c\uc368",
                 "\ub85c\uc368","\uae4c\uc9c0","\ud574\uc57c\ud55c\ub2e4",
                 "\uc77c\uac83\uc774\ub2e4","\ubc18\ub4dc\uc2dc","\ud560\uc904\uc54c\ub2e4",
                 "\ud560\uc218\uc788\ub2e4","\ud560\uc218\uc788\uc5b4","\uc784\uc5d0",
                 "\ud2c0\ub9bc\uc5c6\ub2e4","\ud55c\ub2e4\uba74","\ub4f1",
                 "\ub4f1\ub4f1","\uc81c","\uaca8\uc6b0",
                 "\ub2e8\uc9c0","\ub2e4\ub9cc","\ud560\ubfd0",
                 "\ub529\ub3d9","\ub315\uadf8","\ub300\ud574\uc11c",
                 "\ub300\ud558\uc5ec","\ub300\ud558\uba74","\ud6e8\uc52c",
                 "\uc5bc\ub9c8\ub098","\uc5bc\ub9c8\ub9cc\ud07c","\uc5bc\ub9c8\ud07c",
                 "\ub0a8\uc9d3","\uc5ec","\uc5bc\ub9c8\uac04",
                 "\uc57d\uac04","\ub2e4\uc18c","\uc880",
                 "\uc870\uae08","\ub2e4\uc218","\uba87",
                 "\uc5bc\ub9c8","\uc9c0\ub9cc","\ud558\ubb3c\uba70",
                 "\ub610\ud55c","\uadf8\ub7ec\ub098","\uadf8\ub807\uc9c0\ub9cc",
                 "\ud558\uc9c0\ub9cc","\uc774\uc678\uc5d0\ub3c4","\ub300\ud574",
                 "\ub9d0\ud558\uc790\uba74","\ubfd0\uc774\ub2e4","\ub2e4\uc74c\uc5d0",
                 "\ubc18\ub300\ub85c","\ubc18\ub300\ub85c","\ub9d0\ud558\uc790\uba74",
                 "\uc774\uc640","\ubc18\ub300\ub85c","\ubc14\uafb8\uc5b4\uc11c",
                 "\ub9d0\ud558\uba74","\ubc14\uafb8\uc5b4\uc11c","\ud55c\ub2e4\uba74",
                 "\ub9cc\uc57d","\uadf8\ub807\uc9c0\uc54a\uc73c\uba74","\uae4c\uc545",
                 "\ud22d","\ub531","\uc090\uac71\uac70\ub9ac\ub2e4",
                 "\ubcf4\ub4dc\ub4dd","\ube44\uac71\uac70\ub9ac\ub2e4","\uaf48\ub2f9",
                 "\uc751\ub2f9","\ud574\uc57c\ud55c\ub2e4","\uc5d0",
                 "\uac00\uc11c","\uac01","\uac01\uac01",
                 "\uc5ec\ub7ec\ubd84","\uac01\uc885","\uac01\uc790",
                 "\uc81c\uac01\uae30","\ud558\ub3c4\ub85d\ud558\ub2e4","\uc640",
                 "\uacfc","\uadf8\ub7ec\ubbc0\ub85c","\uadf8\ub798\uc11c",
                 "\uace0\ub85c","\ud55c","\uae4c\ub2ed\uc5d0",
                 "\ud558\uae30","\ub54c\ubb38\uc5d0","\uac70\ub2c8\uc640",
                 "\uc774\uc9c0\ub9cc","\ub300\ud558\uc5ec","\uad00\ud558\uc5ec",
                 "\uad00\ud55c","\uacfc\uc5f0","\uc2e4\ub85c",
                 "\uc544\ub2c8\ub098\ub2e4\ub97c\uac00","\uc0dd\uac01\ud55c\ub300\ub85c","\uc9c4\uc9dc\ub85c",
                 "\ud55c\uc801\uc774\uc788\ub2e4","\ud558\uace4\ud558\uc600\ub2e4","\ud558",
                 "\ud558\ud558","\ud5c8\ud5c8","\uc544\ud558",
                 "\uac70\ubc14","\uc640","\uc624",
                 "\uc65c","\uc5b4\uc9f8\uc11c","\ubb34\uc5c7\ub54c\ubb38\uc5d0",
                 "\uc5b4\ucc0c","\ud558\uaca0\ub294\uac00","\ubb34\uc2a8",
                 "\uc5b4\ub514","\uc5b4\ub290\uacf3","\ub354\uad70\ub2e4\ub098",
                 "\ud558\ubb3c\uba70","\ub354\uc6b1\uc774\ub294","\uc5b4\ub290\ub54c",
                 "\uc5b8\uc81c","\uc57c","\uc774\ubd10",
                 "\uc5b4\uc774","\uc5ec\ubcf4\uc2dc\uc624","\ud750\ud750",
                 "\ud765","\ud734","\ud5c9\ud5c9",
                 "\ud5d0\ub5a1\ud5d0\ub5a1","\uc601\ucc28","\uc5ec\ucc28",
                 "\uc5b4\uae30\uc5ec\ucc28","\ub059\ub059","\uc544\uc57c",
                 "\uc557","\uc544\uc57c","\ucf78\ucf78",
                 "\uc878\uc878","\uc88d\uc88d","\ub69d\ub69d",
                 "\uc8fc\ub8e9\uc8fc\ub8e9","\uc1a8","\uc6b0\ub974\ub974",
                 "\uadf8\ub798\ub3c4","\ub610","\uadf8\ub9ac\uace0",
                 "\ubc14\uafb8\uc5b4\ub9d0\ud558\uba74","\ubc14\uafb8\uc5b4\ub9d0\ud558\uc790\uba74","\ud639\uc740",
                 "\ud639\uc2dc","\ub2f5\ub2e4","\ubc0f",
                 "\uadf8\uc5d0","\ub530\ub974\ub294","\ub54c\uac00",
                 "\ub418\uc5b4","\uc989","\uc9c0\ub4e0\uc9c0",
                 "\uc124\ub839","\uac00\ub839","\ud558\ub354\ub77c\ub3c4",
                 "\ud560\uc9c0\ub77c\ub3c4","\uc77c\uc9c0\ub77c\ub3c4","\uc9c0\ub4e0\uc9c0",
                 "\uba87","\uac70\uc758","\ud558\ub9c8\ud130\uba74",
                 "\uc778\uc820","\uc774\uc820","\ub41c\ubc14\uc5d0\uc57c",
                 "\ub41c\uc774\uc0c1","\ub9cc\ud07c \uc5b4\ucc0c\ub40f\ub4e0","\uadf8\uc704\uc5d0",
                 "\uac8c\ub2e4\uac00","\uc810\uc5d0\uc11c","\ubcf4\uc544",
                 "\ube44\ucd94\uc5b4","\ubcf4\uc544","\uace0\ub824\ud558\uba74",
                 "\ud558\uac8c\ub420\uac83\uc774\ub2e4","\uc77c\uac83\uc774\ub2e4","\ube44\uad50\uc801",
                 "\uc880","\ubcf4\ub2e4\ub354","\ube44\ud558\uba74",
                 "\uc2dc\ud0a4\ub2e4","\ud558\uac8c\ud558\ub2e4","\ud560\ub9cc\ud558\ub2e4",
                 "\uc758\ud574\uc11c","\uc5f0\uc774\uc11c","\uc774\uc5b4\uc11c",
                 "\uc787\ub530\ub77c","\ub4a4\ub530\ub77c","\ub4a4\uc774\uc5b4",
                 "\uacb0\uad6d","\uc758\uc9c0\ud558\uc5ec","\uae30\ub300\uc5ec",
                 "\ud1b5\ud558\uc5ec","\uc790\ub9c8\uc790","\ub354\uc6b1\ub354",
                 "\ubd88\uad6c\ud558\uace0","\uc5bc\ub9c8\ub4e0\uc9c0","\ub9c8\uc74c\ub300\ub85c",
                 "\uc8fc\uc800\ud558\uc9c0","\uc54a\uace0","\uace7",
                 "\uc989\uc2dc","\ubc14\ub85c","\ub2f9\uc7a5",
                 "\ud558\uc790\ub9c8\uc790","\ubc16\uc5d0","\uc548\ub41c\ub2e4",
                 "\ud558\uba74\ub41c\ub2e4","\uadf8\ub798","\uadf8\ub807\uc9c0",
                 "\uc694\ucee8\ub300","\ub2e4\uc2dc","\ub9d0\ud558\uc790\uba74",
                 "\ubc14\uafd4","\ub9d0\ud558\uba74","\uc989",
                 "\uad6c\uccb4\uc801\uc73c\ub85c","\ub9d0\ud558\uc790\uba74","\uc2dc\uc791\ud558\uc5ec",
                 "\uc2dc\ucd08\uc5d0","\uc774\uc0c1","\ud5c8",
                 "\ud5c9","\ud5c8\uac71","\ubc14\uc640\uac19\uc774",
                 "\ud574\ub3c4\uc88b\ub2e4","\ud574\ub3c4\ub41c\ub2e4","\uac8c\ub2e4\uac00",
                 "\ub354\uad6c\ub098","\ud558\ubb3c\uba70","\uc640\ub974\ub974",
                 "\ud30d","\ud37d","\ud384\ub801",
                 "\ub3d9\uc548","\uc774\ub798","\ud558\uace0\uc788\uc5c8\ub2e4",
                 "\uc774\uc5c8\ub2e4","\uc5d0\uc11c","\ub85c\ubd80\ud130",
                 "\uae4c\uc9c0","\uc608\ud558\uba74","\ud588\uc5b4\uc694",
                 "\ud574\uc694","\ud568\uaed8","\uac19\uc774",
                 "\ub354\ubd88\uc5b4","\ub9c8\uc800","\ub9c8\uc800\ub3c4",
                 "\uc591\uc790","\ubaa8\ub450","\uc2b5\ub2c8\ub2e4",
                 "\uac00\uae4c\uc2a4\ub85c","\ud558\ub824\uace0\ud558\ub2e4","\uc988\uc74c\ud558\uc5ec",
                 "\ub2e4\ub978","\ub2e4\ub978","\ubc29\uba74\uc73c\ub85c",
                 "\ud574\ubd10\uc694","\uc2b5\ub2c8\uae4c","\ud588\uc5b4\uc694",
                 "\ub9d0\ud560\uac83\ub3c4","\uc5c6\uace0","\ubb34\ub98e\uc4f0\uace0",
                 "\uac1c\uc758\uce58\uc54a\uace0","\ud558\ub294\uac83\ub9cc","\ubabb\ud558\ub2e4",
                 "\ud558\ub294\uac83\uc774","\ub0ab\ub2e4","\ub9e4",
                 "\ub9e4\ubc88","\ub4e4","\ubaa8",
                 "\uc5b4\ub290\uac83","\uc5b4\ub290","\ub85c\uc368",
                 "\uac16\uace0\ub9d0\ud558\uc790\uba74","\uc5b4\ub514","\uc5b4\ub290\ucabd",
                 "\uc5b4\ub290\uac83","\uc5b4\ub290\ud574","\uc5b4\ub290",
                 "\ub144\ub3c4","\ub77c","\ud574\ub3c4",
                 "\uc5b8\uc820\uac00","\uc5b4\ub5a4\uac83","\uc5b4\ub290\uac83",
                 "\uc800\uae30","\uc800\ucabd","\uc800\uac83",
                 "\uadf8\ub54c","\uadf8\ub7fc","\uadf8\ub7ec\uba74",
                 "\uc694\ub9cc\ud55c\uac78","\uadf8\ub798","\uadf8\ub54c",
                 "\uc800\uac83\ub9cc\ud07c","\uadf8\uc800","\uc774\ub974\uae30\uae4c\uc9c0",
                 "\ud560","\uc904","\uc548\ub2e4",
                 "\ud560","\ud798\uc774","\uc788\ub2e4",
                 "\ub108","\ub108\ud76c","\ub2f9\uc2e0",
                 "\uc5b4\ucc0c","\uc124\ub9c8","\ucc28\ub77c\ub9ac",
                 "\ud560\uc9c0\uc5b8\uc815","\ud560\uc9c0\ub77c\ub3c4","\ud560\ub9dd\uc815",
                 "\ud560\uc9c0\uc5b8\uc815","\uad6c\ud1a0\ud558\ub2e4","\uac8c\uc6b0\ub2e4",
                 "\ud1a0\ud558\ub2e4","\uba54\uc4f0\uac81\ub2e4","\uc606\uc0ac\ub78c",
                 "\ud264","\uccc7","\uc758\uac70\ud558\uc5ec",
                 "\uadfc\uac70\ud558\uc5ec","\uc758\ud574","\ub530\ub77c",
                 "\ud798\uc785\uc5b4","\uadf8","\ub2e4\uc74c",
                 "\ubc84\uae08","\ub450\ubc88\uc9f8\ub85c","\uae30\ud0c0",
                 "\uccab\ubc88\uc9f8\ub85c","\ub098\uba38\uc9c0\ub294","\uadf8\uc911\uc5d0\uc11c",
                 "\uacac\uc9c0\uc5d0\uc11c","\ud615\uc2dd\uc73c\ub85c","\uc4f0\uc5ec",
                 "\uc785\uc7a5\uc5d0\uc11c","\uc704\ud574\uc11c","\ub2e8\uc9c0",
                 "\uc758\ud574\ub418\ub2e4","\ud558\ub3c4\ub85d\uc2dc\ud0a4\ub2e4","\ubfd0\ub9cc\uc544\ub2c8\ub77c",
                 "\ubc18\ub300\ub85c","\uc804\ud6c4","\uc804\uc790",
                 "\uc55e\uc758\uac83","\uc7a0\uc2dc","\uc7a0\uae50",
                 "\ud558\uba74\uc11c","\uadf8\ub807\uc9c0\ub9cc","\ub2e4\uc74c\uc5d0",
                 "\uadf8\ub7ec\ud55c\uc989","\uadf8\ub7f0\uc989","\ub0a8\ub4e4",
                 "\uc544\ubb34\uac70\ub098","\uc5b4\ucc0c\ud558\ub4e0\uc9c0","\uac19\ub2e4",
                 "\ube44\uc2b7\ud558\ub2e4","\uc608\ucee8\ub300","\uc774\ub7f4\uc815\ub3c4\ub85c",
                 "\uc5b4\ub5bb\uac8c","\ub9cc\uc57d","\ub9cc\uc77c",
                 "\uc704\uc5d0\uc11c","\uc11c\uc220\ud55c\ubc14\uc640\uac19\uc774","\uc778",
                 "\ub4ef\ud558\ub2e4","\ud558\uc9c0","\uc54a\ub294\ub2e4\uba74",
                 "\ub9cc\uc57d\uc5d0","\ubb34\uc5c7","\ubb34\uc2a8",
                 "\uc5b4\ub290","\uc5b4\ub5a4","\uc544\ub798\uc717",
                 "\uc870\ucc28","\ud55c\ub370","\uadf8\ub7fc\uc5d0\ub3c4",
                 "\ubd88\uad6c\ud558\uace0","\uc5ec\uc804\ud788","\uc2ec\uc9c0\uc5b4",
                 "\uae4c\uc9c0\ub3c4","\uc870\ucc28\ub3c4","\ud558\uc9c0",
                 "\uc54a\ub3c4\ub85d","\uc54a\uae30","\uc704\ud558\uc5ec",
                 "\ub54c","\uc2dc\uac01","\ubb34\ub835",
                 "\uc2dc\uac04","\ub3d9\uc548","\uc5b4\ub54c",
                 "\uc5b4\ub5a0\ud55c","\ud558\uc5ec\uae08","\ub124",
                 "\uc608","\uc6b0\uc120","\ub204\uad6c",
                 "\ub204\uac00","\uc54c\uaca0\ub294\uac00","\uc544\ubb34\ub3c4",
                 "\uc904\uc740\ubaa8\ub978\ub2e4","\uc904\uc740","\ubab0\ub78f\ub2e4",
                 "\ud558\ub294","\uae40\uc5d0","\uacb8\uc0ac\uacb8\uc0ac",
                 "\ud558\ub294\ubc14","\uadf8\ub7f0","\uae4c\ub2ed\uc5d0",
                 "\ud55c","\uc774\uc720\ub294","\uadf8\ub7ec\ub2c8",
                 "\uadf8\ub7ec\ub2c8\uae4c","\ub54c\ubb38\uc5d0","\uadf8",
                 "\ub108\ud76c","\uadf8\ub4e4","\ub108\ud76c\ub4e4",
                 "\ud0c0\uc778","\uac83","\uac83\ub4e4",
                 "\ub108","\uc704\ud558\uc5ec","\uacf5\ub3d9\uc73c\ub85c",
                 "\ub3d9\uc2dc\uc5d0","\ud558\uae30","\uc704\ud558\uc5ec",
                 "\uc5b4\ucc0c\ud558\uc5ec","\ubb34\uc5c7\ub54c\ubb38\uc5d0","\ubd95\ubd95",
                 "\uc719\uc719","\ub098","\uc6b0\ub9ac",
                 "\uc5c9\uc5c9","\ud718\uc775","\uc719\uc719",
                 "\uc624\ud638","\uc544\ud558","\uc5b4\uca0b\ub4e0",
                 "\ub9cc","\ubabb\ud558\ub2e4    \ud558\uae30\ubcf4\ub2e4\ub294","\ucc28\ub77c\ub9ac",
                 "\ud558\ub294","\ud3b8\uc774","\ub0ab\ub2e4",
                 "\ud750\ud750","\ub180\ub77c\ub2e4","\uc0c1\ub300\uc801\uc73c\ub85c",
                 "\ub9d0\ud558\uc790\uba74","\ub9c8\uce58","\uc544\ub2c8\ub77c\uba74",
                 "\uc27f","\uadf8\ub807\uc9c0","\uc54a\uc73c\uba74",
                 "\uadf8\ub807\uc9c0","\uc54a\ub2e4\uba74","\uc548",
                 "\uadf8\ub7ec\uba74","\uc544\ub2c8\uc5c8\ub2e4\uba74","\ud558\ub4e0\uc9c0",
                 "\uc544\ub2c8\uba74","\uc774\ub77c\uba74","\uc88b\uc544",
                 "\uc54c\uc558\uc5b4","\ud558\ub294\uac83\ub3c4","\uadf8\ub9cc\uc774\ub2e4",
                 "\uc5b4\uca54\uc218","\uc5c6\ub2e4","\ud558\ub098",
                 "\uc77c","\uc77c\ubc18\uc801\uc73c\ub85c","\uc77c\ub2e8",
                 "\ud55c\ucf20\uc73c\ub85c\ub294","\uc624\uc790\ub9c8\uc790","\uc774\ub807\uac8c\ub418\uba74",
                 "\uc774\uc640\uac19\ub2e4\uba74","\uc804\ubd80","\ud55c\ub9c8\ub514",
                 "\ud55c\ud56d\ubaa9","\uadfc\uac70\ub85c","\ud558\uae30\uc5d0",
                 "\uc544\uc6b8\ub7ec","\ud558\uc9c0","\uc54a\ub3c4\ub85d",
                 "\uc54a\uae30","\uc704\ud574\uc11c","\uc774\ub974\uae30\uae4c\uc9c0",
                 "\uc774","\ub418\ub2e4","\ub85c",
                 "\uc778\ud558\uc5ec","\uae4c\ub2ed\uc73c\ub85c","\uc774\uc720\ub9cc\uc73c\ub85c",
                 "\uc774\ub85c","\uc778\ud558\uc5ec","\uadf8\ub798\uc11c",
                 "\uc774","\ub54c\ubb38\uc5d0","\uadf8\ub7ec\ubbc0\ub85c",
                 "\uadf8\ub7f0","\uae4c\ub2ed\uc5d0","\uc54c",
                 "\uc218","\uc788\ub2e4","\uacb0\ub860\uc744",
                 "\ub0bc","\uc218","\uc788\ub2e4",
                 "\uc73c\ub85c","\uc778\ud558\uc5ec","\uc788\ub2e4",
                 "\uc5b4\ub5a4\uac83","\uad00\uacc4\uac00","\uc788\ub2e4",
                 "\uad00\ub828\uc774","\uc788\ub2e4","\uc5f0\uad00\ub418\ub2e4",
                 "\uc5b4\ub5a4\uac83\ub4e4","\uc5d0","\ub300\ud574",
                 "\uc774\ub9ac\ud558\uc5ec","\uadf8\ub9ac\ud558\uc5ec","\uc5ec\ubd80",
                 "\ud558\uae30\ubcf4\ub2e4\ub294","\ud558\ub290\ub2c8","\ud558\uba74",
                 "\ud560\uc218\ub85d","\uc6b4\uc6b4","\uc774\ub7ec\uc774\ub7ec\ud558\ub2e4",
                 "\ud558\uad6c\ub098","\ud558\ub3c4\ub2e4","\ub2e4\uc2dc\ub9d0\ud558\uba74",
                 "\ub2e4\uc74c\uc73c\ub85c","\uc5d0","\uc788\ub2e4",
                 "\uc5d0","\ub2ec\ub824","\uc788\ub2e4",
                 "\uc6b0\ub9ac","\uc6b0\ub9ac\ub4e4","\uc624\ud788\ub824",
                 "\ud558\uae30\ub294\ud55c\ub370","\uc5b4\ub5bb\uac8c","\uc5b4\ub5bb\ud574",
                 "\uc5b4\ucc0c\ub40f\uc5b4","\uc5b4\ub54c","\uc5b4\uc9f8\uc11c",
                 "\ubcf8\ub300\ub85c","\uc790","\uc774",
                 "\uc774\ucabd","\uc5ec\uae30","\uc774\uac83",
                 "\uc774\ubc88","\uc774\ub807\uac8c\ub9d0\ud558\uc790\uba74","\uc774\ub7f0",
                 "\uc774\ub7ec\ud55c","\uc774\uc640","\uac19\uc740",
                 "\uc694\ub9cc\ud07c","\uc694\ub9cc\ud55c","\uac83",
                 "\uc5bc\ub9c8","\uc548","\ub418\ub294",
                 "\uac83","\uc774\ub9cc\ud07c","\uc774",
                 "\uc815\ub3c4\uc758","\uc774\ub807\uac8c","\ub9ce\uc740",
                 "\uac83","\uc774\uc640","\uac19\ub2e4",
                 "\uc774\ub54c","\uc774\ub807\uad6c\ub098","\uac83\uacfc",
                 "\uac19\uc774","\ub07c\uc775","\uc090\uac71",
                 "\ub530\uc704","\uc640","\uac19\uc740",
                 "\uc0ac\ub78c\ub4e4","\ubd80\ub958\uc758","\uc0ac\ub78c\ub4e4",
                 "\uc65c\ub0d0\ud558\uba74","\uc911\uc758\ud558\ub098","\uc624\uc9c1",
                 "\uc624\ub85c\uc9c0","\uc5d0","\ud55c\ud558\ub2e4",
                 "\ud558\uae30\ub9cc","\ud558\uba74","\ub3c4\ucc29\ud558\ub2e4",
                 "\uae4c\uc9c0","\ubbf8\uce58\ub2e4","\ub3c4\ub2ec\ud558\ub2e4",
                 "\uc815\ub3c4\uc5d0","\uc774\ub974\ub2e4","\ud560",
                 "\uc9c0\uacbd\uc774\ub2e4","\uacb0\uacfc\uc5d0","\uc774\ub974\ub2e4",
                 "\uad00\ud574\uc11c\ub294","\uc5ec\ub7ec\ubd84","\ud558\uace0",
                 "\uc788\ub2e4","\ud55c","\ud6c4",
                 "\ud63c\uc790","\uc790\uae30","\uc790\uae30\uc9d1",
                 "\uc790\uc2e0","\uc6b0\uc5d0","\uc885\ud569\ud55c\uac83\uacfc\uac19\uc774",
                 "\ucd1d\uc801\uc73c\ub85c","\ubcf4\uba74","\ucd1d\uc801\uc73c\ub85c",
                 "\ub9d0\ud558\uba74","\ucd1d\uc801\uc73c\ub85c","\ub300\ub85c",
                 "\ud558\ub2e4","\uc73c\ub85c\uc11c","\ucc38",
                 "\uadf8\ub9cc\uc774\ub2e4","\ud560","\ub530\ub984\uc774\ub2e4",
                 "\ucff5","\ud0d5\ud0d5","\ucf85\ucf85",
                 "\ub465\ub465","\ubd10","\ubd10\ub77c",
                 "\uc544\uc774\uc57c","\uc544\ub2c8","\uc640\uc544",
                 "\uc751","\uc544\uc774","\ucc38\ub098",
                 "\ub144","\uc6d4","\uc77c",
                 "\ub839","\uc601","\uc77c",
                 "\uc774","\uc0bc","\uc0ac",
                 "\uc624","\uc721","\ub959",
                 "\uce60","\ud314","\uad6c",
                 "\uc774\ucc9c\uc721","\uc774\ucc9c\uce60","\uc774\ucc9c\ud314",
                 "\uc774\ucc9c\uad6c","\ud558\ub098","\ub458",
                 "\uc14b","\ub137","\ub2e4\uc12f",
                 "\uc5ec\uc12f","\uc77c\uacf1","\uc5ec\ub35f",
                 "\uc544\ud649","\ub839","\uc601"
  )

  requireNamespace("KoNLP", quietly = TRUE)
  nouns <- KoNLP::extractNoun(sentence)
  stopword <- list()

  i <- 1
  for (noun in nouns) {
    if (stringi::stri_escape_unicode(noun) %in% stopwords)
      stopword[i] <- FALSE else stopword[i] <- TRUE
      i <- i + 1
  }
  return(table(nouns[unlist(stopword)]))
}

#' Convert sentence to word table except stopword.
#' Example will be shown in \href{https://github.com/mikigom/Rtextrankr}{github}.
#'
#' @param table A table which refers word frequency.
#' @return A generalized set which refers word frequency.
table2gset <- function(table) {
  return(gset(names(table), matrix(table)[1:nrow(table), ]))
}

#' Calculate a Jaccard Index between two sentences.
#' Example will be shown in \href{https://github.com/mikigom/Rtextrankr}{github}.
#'
#' @param sentence1 The first character string.
#' @param sentence2 The second character string.
#' @return a Jaccard Index between two sentences by generalized set of noun word.
#' @references Tan, Pang-Ning; Steinbach, Michael; Kumar, Vipin (2005), Introduction to Data Mining, ISBN 0-321-32136-7.
co_occurence <- function(sentence1, sentence2) {
  bow1 <- table2gset(sentence2table(sentence1))
  bow2 <- table2gset(sentence2table(sentence2))

  p <- sum(sets::gset_memberships(bow1 & bow2))
  q <- sum(sets::gset_memberships(bow1 | bow2))

  if (q == 0)
    return(0) else return(p/q)
}

#' Make character string list which ends with a period, from the whole text.
#' Example will be shown in \href{https://github.com/mikigom/Rtextrankr}{github}.
#'
#' @param text The long character string including delimiter([.|!|?|blank line]).
#' @return The list of character string which ends with a period.
get_sentences <- function(text) {
  candidates <- xplit(text)
  sentences <- list()

  i <- 1
  for (candidate in candidates) {
    if (substr(candidate, 1, 1) == " ")
      candidates[i] <- substr(candidate, 2, nchar(candidate))
    i <- i + 1
  }

  i <- 1
  for (candidate in candidates) {
    while (nchar(candidate) == 0 && (substr(candidate, nchar(candidate),
                                            nchar(candidate)) == "." || substr(candidate, nchar(candidate),
                                                                               nchar(candidate)) == " ")) candidate <- unlist(strsplit(candidate,
                                                                                                                                       "[ |.]"))
    if (nchar(candidate))
      candidates[i] <- paste(candidate, ".", sep = "")
    i <- i + 1
  }

  return(candidates[nchar(candidates) > 0])
}

#' Make a graph which refers relationship of sentences.
#' Vertex refers one sentence, and edge refers co-occurence between two sentences.
#' Example will be shown in \href{https://github.com/mikigom/Rtextrankr}{github}.
#'
#' @param sentences The list of character string.
#' @return The igraph graph which refers relationship of sentences.
build_graph <- function(sentences) {
  graph <- make_empty_graph()
  invisible(capture.output(
    for(sentence in sentences){
      graph <- graph + vertices(sentence)
    }
  ))

  pairs <- t(combn(as.vector(sentences), 2))

  for (k in 1:nrow(pairs)) {
    invisible(capture.output(graph <- graph + edges(c(pairs[k, 1],
                                                      pairs[k, 2]), weight = co_occurence(pairs[k, 1], pairs[k, 2]))))
    invisible(capture.output(graph <- graph + edges(c(pairs[k, 2],
                                                      pairs[k, 1]), weight = co_occurence(pairs[k, 2], pairs[k, 1]))))
  }

  return(graph)
}

#' Return list of character string of the most important sentences by Textrank algorithm.
#' Example will be shown in \href{https://github.com/mikigom/Rtextrankr}{github}.
#'
#' @param text The long character string including delimiter([.|!|?|blank line]).
#' @param count The number of summarized sentences.
#' @return The list of character string of the most important sentences by Textrank algorithm.
#' @references Mihalcea, R., & Tarau, P. (2004, July). TextRank: Bringing order into texts. Association for Computational Linguistics.
summarize <- function(text, count) {
  sentences <- get_sentences(text)
  graph <- build_graph(sentences)
  pagerank <- page_rank(graph, directed = FALSE)
  pagerank_sored_index <- sort(pagerank$vector, method = "shell", decreasing = TRUE,
                               index.return = TRUE)$ix

  result <- list()
  for (n in 1:count) result[n] <- names(pagerank$vector)[pagerank_sored_index[n]]

  return(unlist(result))
}
