extends Control
class_name MainMenu

# MainMenu: AAA Console Hub Inspired by World Cricket Championship 3 (WCC3) & RC24
# Features: Profile Status Bar, VIP Level Badge, Currency Counters, 5 High-Impact Mode Cards,
# Live News Ticker & Tactile Sports UI Audio.

var scroll_container: ScrollContainer
var ticker_label: Label
var ticker_offset: float = 1280.0

func _ready() -> void:
	_build_ui()

func _process(delta: float) -> void:
	# Smooth marquee scrolling news ticker
	if ticker_label:
		ticker_offset -= delta * 75.0
		if ticker_offset < -900.0:
			ticker_offset = 1280.0
		ticker_label.position.x = ticker_offset

func _build_ui() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0

	# 1. Dark Carbon Hexagonal Stadium Backdrop
	var bg := ColorRect.new()
	bg.anchor_right = 1.0
	bg.anchor_bottom = 1.0
	bg.color = Color(0.05, 0.07, 0.11)
	add_child(bg)

	# 2. TOP VIP PROFILE & BROADCAST STATUS BAR (WCC3 STYLE)
	var header := PanelContainer.new()
	header.anchor_right = 1.0
	header.custom_minimum_size = Vector2(0, 72)
	var style_h := StyleBoxFlat.new()
	style_h.bg_color = Color(0.08, 0.11, 0.17, 0.96)
	style_h.border_width_bottom = 3
	style_h.border_color = Color(0.95, 0.75, 0.15) # Championship Gold
	header.add_theme_stylebox_override("panel", style_h)
	add_child(header)

	var hbox_h := HBoxContainer.new()
	hbox_h.offset_left = 24
	hbox_h.offset_right = -24
	hbox_h.add_theme_constant_override("separation", 20)
	header.add_child(hbox_h)

	# Left: Player Avatar Badge
	var avatar_box := HBoxContainer.new()
	avatar_box.add_theme_constant_override("separation", 12)
	hbox_h.add_child(avatar_box)

	var badge := PanelContainer.new()
	badge.custom_minimum_size = Vector2(48, 48)
	var style_b := StyleBoxFlat.new()
	style_b.bg_color = Color(0.95, 0.75, 0.15)
	style_b.corner_radius_top_left = 24
	style_b.corner_radius_top_right = 24
	style_b.corner_radius_bottom_left = 24
	style_b.corner_radius_bottom_right = 24
	badge.add_theme_stylebox_override("panel", style_b)
	avatar_box.add_child(badge)

	var badge_lbl := Label.new()
	badge_lbl.text = "⭐"
	badge_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	badge.add_child(badge_lbl)

	var player_vbox := VBoxContainer.new()
	player_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	avatar_box.add_child(player_vbox)

	var name_lbl := Label.new()
	var cap_name: String = DataManager.custom_player.get("name", "VIKRAM SHARMA")
	if cap_name.is_empty():
		cap_name = "CAPTAIN VIKRAM"
	name_lbl.text = cap_name.to_upper()
	name_lbl.add_theme_font_size_override("font_size", 16)
	name_lbl.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
	player_vbox.add_child(name_lbl)

	var level_lbl := Label.new()
	level_lbl.text = "LVL 42 • MASTER CLASS"
	level_lbl.add_theme_font_size_override("font_size", 11)
	level_lbl.add_theme_color_override("font_color", Color(0.2, 0.85, 1.0))
	player_vbox.add_child(level_lbl)

	# Center Spacer
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox_h.add_child(spacer)

	# Center Logo Title
	var title_lbl := Label.new()
	title_lbl.text = "🏏 CRICSTRIKE 3D"
	title_lbl.add_theme_font_size_override("font_size", 22)
	title_lbl.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2))
	hbox_h.add_child(title_lbl)

	var spacer2 := Control.new()
	spacer2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox_h.add_child(spacer2)

	# Right: Currencies & Settings
	var cur_box := HBoxContainer.new()
	cur_box.add_theme_constant_override("separation", 16)
	hbox_h.add_child(cur_box)

	var coins_card := PanelContainer.new()
	var style_c := StyleBoxFlat.new()
	style_c.bg_color = Color(0.12, 0.16, 0.24)
	style_c.corner_radius_top_left = 14
	style_c.corner_radius_top_right = 14
	style_c.corner_radius_bottom_left = 14
	style_c.corner_radius_bottom_right = 14
	style_c.content_margin_left = 12
	style_c.content_margin_right = 12
	style_c.content_margin_top = 6
	style_c.content_margin_bottom = 6
	coins_card.add_theme_stylebox_override("panel", style_c)
	cur_box.add_child(coins_card)

	var coins_lbl := Label.new()
	coins_lbl.text = "🪙 ₹%s" % _format_number(DataManager.profile["coins"])
	coins_lbl.add_theme_font_size_override("font_size", 14)
	coins_lbl.add_theme_color_override("font_color", Color(0.95, 0.85, 0.25))
	coins_card.add_child(coins_lbl)

	var token_card := PanelContainer.new()
	token_card.add_theme_stylebox_override("panel", style_c)
	cur_box.add_child(token_card)

	var token_lbl := Label.new()
	token_lbl.text = "💎 4,500"
	token_lbl.add_theme_font_size_override("font_size", 14)
	token_lbl.add_theme_color_override("font_color", Color(0.2, 0.85, 1.0))
	token_card.add_child(token_lbl)

	# 3. HORIZONTAL SCROLLING WCC3 GAME MODE CARDS
	scroll_container = ScrollContainer.new()
	scroll_container.anchor_top = 0.0
	scroll_container.anchor_bottom = 1.0
	scroll_container.anchor_left = 0.0
	scroll_container.anchor_right = 1.0
	scroll_container.offset_top = 95
	scroll_container.offset_bottom = -60
	scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll_container)

	var hbox_cards := HBoxContainer.new()
	hbox_cards.add_theme_constant_override("separation", 24)
	hbox_cards.offset_left = 32
	hbox_cards.offset_right = 32
	scroll_container.add_child(hbox_cards)

	# Spacer
	var lead_spacer := Control.new()
	lead_spacer.custom_minimum_size = Vector2(16, 0)
	hbox_cards.add_child(lead_spacer)

	# CARD 1: SUPER OVER (High Voltage)
	hbox_cards.add_child(_create_wcc3_mode_card(
		"⚡ SUPER OVER",
		"🔥 INSTANT 6-BALL CHASE",
		"Last-over thriller scenario. Defend 18 runs or blast consecutive sixes to claim victory!",
		Color(0.85, 0.18, 0.18),
		Color(0.95, 0.45, 0.12),
		func():
			GameManager.setup_match("IND", "AUS", 1, "GREEN_TURF", "HARD", GameManager.GameMode.SUPER_OVER)
			get_tree().change_scene_to_file("res://scenes/match.tscn")
	))

	# CARD 2: QUICK MATCH (Exhibition)
	hbox_cards.add_child(_create_wcc3_mode_card(
		"🏏 QUICK MATCH",
		"⚡ EXHIBITION CLASH",
		"Select any 2 international titans (IND, AUS, ENG, PAK). Choose overs, pitch surface and difficulty.",
		Color(0.12, 0.45, 0.88),
		Color(0.25, 0.75, 1.0),
		func():
			get_tree().change_scene_to_file("res://scenes/quick_match.tscn")
	))

	# CARD 3: WORLD TOURNAMENT (Asia & World Cup)
	hbox_cards.add_child(_create_wcc3_mode_card(
		"🏆 WORLD TOURNAMENT",
		"👑 CHAMPIONSHIP TROPHY",
		"8-Nation round-robin bracket. Compete in group stages, track live NRR points table, and lift the World Cup!",
		Color(0.85, 0.65, 0.12),
		Color(1.0, 0.85, 0.25),
		func():
			get_tree().change_scene_to_file("res://scenes/tournament.tscn")
	))

	# CARD 4: PREMIER LEAGUE MEGA AUCTION
	hbox_cards.add_child(_create_wcc3_mode_card(
		"💰 MEGA AUCTION",
		"💎 ₹100 CRORE PURSE",
		"Engage in intense live bidding wars against rival franchise AI teams. Scout 40 marquee cricketers!",
		Color(0.15, 0.68, 0.35),
		Color(0.25, 0.90, 0.45),
		func():
			get_tree().change_scene_to_file("res://scenes/auction.tscn")
	))

	# CARD 5: LOCKER ROOM & CUSTOMIZER
	hbox_cards.add_child(_create_wcc3_mode_card(
		"👕 LOCKER ROOM",
		"✨ 360° 3D STUDIO",
		"Custom player anatomy, athletic builds, international kits, English Willow bats & MRF/CEAT sponsor decals.",
		Color(0.52, 0.22, 0.85),
		Color(0.75, 0.35, 1.0),
		func():
			get_tree().change_scene_to_file("res://scenes/locker_room.tscn")
	))

	# 4. BOTTOM TV LIVE NEWS TICKER
	var ticker_bar := PanelContainer.new()
	ticker_bar.anchor_top = 1.0
	ticker_bar.anchor_right = 1.0
	ticker_bar.anchor_bottom = 1.0
	ticker_bar.offset_top = -48
	var style_t := StyleBoxFlat.new()
	style_t.bg_color = Color(0.04, 0.06, 0.09, 0.98)
	style_t.border_width_top = 2
	style_t.border_color = Color(0.95, 0.75, 0.15)
	ticker_bar.add_theme_stylebox_override("panel", style_t)
	add_child(ticker_bar)

	var ticker_clip := Control.new()
	ticker_clip.clip_contents = true
	ticker_clip.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ticker_bar.add_child(ticker_clip)

	ticker_label = Label.new()
	ticker_label.text = "🔴 LIVE NEWS: ICC WORLD CHAMPIONSHIP • TOURNAMENT LEADER: INDIA (+1.500 NRR) • TOP RUN SCORER: V. KOHLI (482 RUNS) • TOP WICKET TAKER: J. BUMRAH (18 WICKETS) • CRICSTRIKE 3D MASTER CONSOLE EDITION • 100% OFFLINE ZERO PAYWALLS"
	ticker_label.add_theme_font_size_override("font_size", 13)
	ticker_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.3))
	ticker_label.position = Vector2(1280, 14)
	ticker_clip.add_child(ticker_label)

func _create_wcc3_mode_card(title: String, badge_text: String, desc: String, col_primary: Color, col_glow: Color, on_click: Callable) -> Control:
	var container := PanelContainer.new()
	container.custom_minimum_size = Vector2(250, 470)
	
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.09, 0.12, 0.18, 0.95)
	style.border_width_left = 3
	style.border_width_right = 3
	style.border_width_top = 3
	style.border_width_bottom = 3
	style.border_color = col_glow
	style.corner_radius_top_left = 18
	style.corner_radius_top_right = 18
	style.corner_radius_bottom_left = 18
	style.corner_radius_bottom_right = 18
	style.shadow_color = Color(col_primary.r, col_primary.g, col_primary.b, 0.35)
	style.shadow_size = 8
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 22
	style.content_margin_bottom = 22
	container.add_theme_stylebox_override("panel", style)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 14)
	container.add_child(vbox)

	# Category Badge Tag
	var badge_panel := PanelContainer.new()
	badge_panel.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	var style_tag := StyleBoxFlat.new()
	style_tag.bg_color = col_primary
	style_tag.corner_radius_top_left = 8
	style_tag.corner_radius_top_right = 8
	style_tag.corner_radius_bottom_left = 8
	style_tag.corner_radius_bottom_right = 8
	style_tag.content_margin_left = 10
	style_tag.content_margin_right = 10
	style_tag.content_margin_top = 4
	style_tag.content_margin_bottom = 4
	badge_panel.add_theme_stylebox_override("panel", style_tag)
	vbox.add_child(badge_panel)

	var badge_lbl := Label.new()
	badge_lbl.text = badge_text
	badge_lbl.add_theme_font_size_override("font_size", 11)
	badge_lbl.add_theme_color_override("font_color", Color.WHITE)
	badge_panel.add_child(badge_lbl)

	# Main Title
	var title_lbl := Label.new()
	title_lbl.text = title
	title_lbl.add_theme_font_size_override("font_size", 20)
	title_lbl.add_theme_color_override("font_color", col_glow)
	vbox.add_child(title_lbl)

	# Description Text
	var desc_lbl := Label.new()
	desc_lbl.text = desc
	desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
	desc_lbl.add_theme_font_size_override("font_size", 13)
	desc_lbl.add_theme_color_override("font_color", Color(0.75, 0.80, 0.88))
	desc_lbl.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(desc_lbl)

	# Big Action Play Button
	var btn := Button.new()
	btn.text = "PLAY NOW ▶"
	btn.custom_minimum_size = Vector2(0, 52)
	btn.add_theme_font_size_override("font_size", 15)
	var style_btn := StyleBoxFlat.new()
	style_btn.bg_color = col_primary
	style_btn.corner_radius_top_left = 12
	style_btn.corner_radius_top_right = 12
	style_btn.corner_radius_bottom_left = 12
	style_btn.corner_radius_bottom_right = 12
	style_btn.shadow_color = Color(0, 0, 0, 0.4)
	style_btn.shadow_size = 4
	btn.add_theme_stylebox_override("normal", style_btn)
	btn.pressed.connect(on_click)
	vbox.add_child(btn)

	return container

func _format_number(val: int) -> String:
	var s: String = str(val)
	var res: String = ""
	var count: int = 0
	for i in range(s.length() - 1, -1, -1):
		res = s[i] + res
		count += 1
		if count % 3 == 0 and i > 0:
			res = "," + res
	return res
