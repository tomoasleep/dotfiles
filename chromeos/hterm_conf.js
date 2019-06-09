const colors = [
	"#073642",  /*  0: black    */
	"#dc322f",  /*  1: red      */
	"#859900",  /*  2: green    */
	"#b58900",  /*  3: yellow   */
	"#268bd2",  /*  4: blue     */
	"#d33682",  /*  5: magenta  */
	"#2aa198",  /*  6: cyan     */
	"#eee8d5",  /*  7: white    */
	"#002b36",  /*  8: brblack  */
	"#cb4b16",  /*  9: brred    */
	"#586e75",  /* 10: brgreen  */
	"#657b83",  /* 11: bryellow */
	"#839496",  /* 12: brblue   */
	"#6c71c4",  /* 13: brmagenta*/
	"#93a1a1",  /* 14: brcyan   */
	"#fdf6e3",  /* 15: brwhite  */
];

term_.prefs_.set('color-palette-overrides', colors);
term_.prefs_.set('background-color', colors[15]);
term_.prefs_.set('foreground-color', colors[11]);
term_.prefs_.set('cursor-color', 'rgba(101, 123, 131, 0.5)');
term_.prefs_.set('scroll-wheel-may-send-arrow-keys', true);
term_.prefs_.set('keybindings', {
  "Ctrl-Shift-Space": "PASS",
  "Ctrl-Space": "PASS"
});
term_.prefs_.set('font-family', '"Noto Sans Mono", "Noto Sans Mono CJK JP", "DejaVu Sans Mono", "Everson Mono", FreeMono, Menlo, Terminal, monospace');
