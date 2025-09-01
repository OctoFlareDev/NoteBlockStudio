function control_draw() {
	// control_draw()
	var a, b, c, d, e, f, g, p, l, s, exist, str, str2, m, xx, x1, y1, x2, y2, iconcolor, showmenu, totalcols, totalrows, compx, prev, colr, note_offset;

	var checkplaying = playing - playing_prev
	playing_prev = playing
	
	var current_song = songs[song]
	var tabwidth = 180
	if (179 * array_length(songs) + 30 > rw - 14) tabwidth = (rw - 14 - 30) / array_length(songs) + 1
	
	song_tab_offset = get_tab_offset()
	
	var song_tab_texty = get_tab_texty()
	
	var remove_emitters_all_schedule = 0

	rw = floor(window_width * (1 / window_scale))
	rh = floor(window_height * (1 / window_scale))
	
	var centerx = floor(rw / 2)
	var centery = floor(rh / 2)
	
	update_window_scale()
	
	if (!mouseover) curs = cr_default
	showmenu = 0
	cursmarker = 0
	compx = 160
	
	draw_set_alpha(1)
	draw_theme_color()
	draw_theme_font(font_main)

	if (theme = 0) window_background = 15790320
	if (theme = 1) window_background = 13160660
	if (theme = 2) window_background = c_dark
	// if (theme = 3) window_background = c_white
	if (theme = 3) window_background = 15987699
	if (theme = 3 && fdark) window_background = 2105376
	draw_clear(window_background)
	if (theme = 3 && acrylic && wpaperexist && can_draw_mica) {
		var wpapertodraw = wpaperblur
		if (wpapernoblur = 1) wpapertodraw = wpaper
		var wpaperscale = 1
		if (wpaperanchor = 0) {
			wpaperscale = (1 / window_scale) * (display_width / sprite_get_width(wpaper)) * (!wpaperside) + (1 / window_scale) * (display_height / sprite_get_height(wpaper)) * (wpaperside)
			draw_sprite_tiled_ext(wpapertodraw, 0,
			0 - window_get_x() * (1 / window_scale) - (sprite_get_width(wpaper) * (display_height / sprite_get_height(wpaper)) - display_width) * (1 / window_scale) * (wpaperside) / 2,
			0 - window_get_y() * (1 / window_scale) - (sprite_get_height(wpaper) * (display_width / sprite_get_width(wpaper)) - display_height) * (1 / window_scale) * (!wpaperside) / 2,
			wpaperscale,
			wpaperscale, -1, 1)
		}
		else if (wpaperanchor = 1) {
			wpaperscale = (1 / window_scale) * (window_width / sprite_get_width(wpaper)) * (!wpaperside) + (1 / window_scale) * (window_height / sprite_get_height(wpaper)) * (wpaperside)
			draw_sprite_ext(wpapertodraw, 0,
			(rw - sprite_get_width(wpaper) * wpaperscale) / 2,
			(rh - sprite_get_height(wpaper) * wpaperscale) / 2,
			wpaperscale,
			wpaperscale, 0, -1, 1)
		}
	}
	if (theme = 3 && ((rainbowtoggle && backgroundrainbow) || backgroundaccent)) {
		draw_set_color(accent[3])
		draw_rectangle(0, 0, rw, rh, 0)
	}
	draw_set_color(15790320)
	if (theme = 1) draw_set_color(13160660)
	if (theme = 2) draw_set_color(c_dark)
	if (theme = 3) draw_set_color(15987699)
	if (theme = 3 && acrylic && wpaperexist && can_draw_mica) draw_set_color(15198183)
	if (theme = 3 && fdark) draw_set_color(2105376)
	if (theme = 3 && fdark && acrylic && wpaperexist && can_draw_mica) draw_set_color(1315860)
	if (theme = 3 && acrylic && wpaperexist && can_draw_mica) draw_set_alpha(0.875)
	if (theme != 3 or !wpapernodim) draw_rectangle(0, 0, rw, rh, 0)
	draw_set_alpha(1)

	iconcolor = c_white

	// Calculate area
	totalcols = floor(rh / 32) + 1
	rhval = 270 + song_tab_offset
	totalrows = floor((rh - rhval) / 32)
	if (min(keysmax, floor((rw - 32) / 39)) != keysshow) {
	    if (!isplayer) startkey = 27 - floor(min(keysmax, floor((rw - 32) / 39)) / 2)
		else startkey = 0
	    sharpkeys = 0
	    for (a = 0; a < startkey; a += 1) {
	        b = a mod 7
	        if (b != 1 && b != 4) sharpkeys += 1
	    }
	}
	keysshow = min(keysmax, floor((rw - 32) / 39))
	x1 = -2
	x1 = 264
	y1 = 52 + song_tab_offset
	exist = 0

	// Draw note blocks
	draw_set_halign(fa_center)
	for (b = 0; b <= totalrows; b += 1) {
	    lockedlayer[current_song.startb + b] = 0
	    if (current_song.solostr != "") {
	        if (string_count("|" + string(current_song.startb + b) + "|", current_song.solostr) = 0) {
	            lockedlayer[current_song.startb + b] = 1
	        } else if (current_song.layerlock[current_song.startb + b] = 1) {
	            lockedlayer[current_song.startb + b] = 1
	        }
	    } else if (current_song.startb + b < current_song.endb2) {
	        if (current_song.layerlock[current_song.startb + b] = 1) {
	            lockedlayer[current_song.startb + b] = 1
	        }
	    }
	}
	note_offset = floor(((current_song.marker_pos - floor(current_song.marker_pos + 0.5 * !isplayer)) * 32) + 0.5) * ((playing && marker_follow && marker_pagebypage = 2 && (current_song.marker_pos - floor(totalcols / 2 + 0.5) < current_song.enda + 1 && current_song.marker_pos - floor(totalcols / 2 + 0.5) > 0)) || isplayer)
	
	draw_set_alpha(1)
	draw_set_halign(fa_left)

	if (checkplaying > 0) {
		if (current_song.reference_option > 0 && !audio_is_playing(current_song.reference_sound)) {
			current_song.reference_sound = audio_play_sound(current_song.reference_audio, 1, 0)
			audio_sound_gain(current_song.reference_audio, (current_song.reference_volume * mastervol) / 100, 0)
			audio_sound_set_track_position(current_song.reference_sound, get_seconds_from_tick(current_song.marker_pos) + current_song.reference_offset / 1000)
		}
	}
	if (checkplaying < 0) {
		for (var i = 0; i < array_length(songs); i++) {
			if (audio_is_playing(songs[i].reference_sound)) audio_stop_sound(songs[i].reference_sound)
		}
	}

	// Draw selection
	current_song.marker_prevpos = current_song.marker_pos
	// Keyboard shortcuts
	if (window = 0 && text_focus = -1) {
		// Instrument shortcuts
		if (keyboard_check_pressed(vk_f5) && keyboard_check(vk_control) && keyboard_check(vk_shift) && theme = 3) {
			rainbowtoggle = !rainbowtoggle
			if (language != 1) {
			if (rainbowtoggle) {
				set_msg("Rainbow mode => ON")
			} else {
				set_msg("Rainbow mode => OFF")
				draw_accent_init()
			}
			} else {
			if (rainbowtoggle) {
				set_msg("炫彩模式 => ON")
			} else {
				set_msg("炫彩模式 => OFF")
				draw_accent_init()
			}
			}
		}
	}
	if (keyboard_check_pressed(vk_f7) && playing = 0) {
	    if (refreshrate = 0){
			game_set_speed(60,gamespeed_fps)
			refreshrate = 1
			if (language != 1) set_msg("Max framerate => 60 FPS")
			else set_msg("帧数上限 => 60 FPS")
		} else if (refreshrate = 1) {
			game_set_speed(120,gamespeed_fps)
			refreshrate = 2
			if (language != 1) set_msg("Max framerate => 120 FPS")
			else set_msg("帧数上限 => 120 FPS")
		} else if (refreshrate = 2) {
			game_set_speed(144,gamespeed_fps)
			refreshrate = 3
			if (language != 1) set_msg("Max framerate => 144 FPS")
			else set_msg("帧数上限 => 144 FPS")
		} else if (refreshrate = 3) {
			game_set_speed(240,gamespeed_fps)
			refreshrate = 4
			if (language != 1) set_msg("Max framerate => 240 FPS")
			else set_msg("帧数上限 => 240 FPS")
		} else if (refreshrate = 4) {
			game_set_speed(30,gamespeed_fps)
			refreshrate = 0
			if (language != 1) set_msg("Max framerate => 30 FPS")
			else set_msg("帧数上限 => 30 FPS")
		}
	}
	if (keyboard_check_released(vk_f3) && !debug_option) debug_overlay = !debug_overlay
	if (keyboard_check(vk_f3)) {
		if (keyboard_check_released(ord("C"))){
			window = 0
			debug_option = 1
			set_msg("[Debug] Window => 0")
		}
		if (keyboard_check_released(ord("G"))) {
			window = w_greeting
			debug_option = 1
			set_msg("[Debug] Window => w_greeting")
		}
		if (keyboard_check_released(ord("D"))) {
			debug_overlay_ingame = !debug_overlay_ingame
			show_debug_overlay(debug_overlay_ingame)
			debug_option = 1
		}
		if (keyboard_check_released(ord("L"))) {
			logs_overlay = !logs_overlay
			debug_option = 1
		}
		//if (keyboard_check_released(ord("D")) && isplayer) {
		//	if (!dropmode) window_maximize()
		//	//else window_set_size(floor(800 * window_scale), floor(500 * window_scale))
		//	else window_setnormal()
		//	dropmode = !dropmode
		//	debug_option = 1
		//	set_msg("[Debug] Toggle experimental drop mode")
		//}
	}
	if (keyboard_check_released(vk_f3)) debug_option = 0
	
	// Marker
	if (playing = 0) metronome_played = -1
	if (playing = 1 || forward<>0) {
	    if (playing = 1) current_song.marker_pos += (current_song.tempo / room_speed) * (1 / currspeed)
	    if (forward != 0) {
	        current_song.marker_pos += (current_song.tempo / room_speed) * (1 / currspeed) * (forward - (forward < 0 && playing = 1))
	    }
		//loop song
		if (current_song.loop_session = 1 && current_song.marker_pos > current_song.enda + 1) { // && (!looptobarend || current_song.marker_pos mod (current_song.timesignature * 4) < 1)
			--timestoloop
			current_song.starta = current_song.loopstart
			current_song.marker_pos = current_song.starta
			metronome_played = -1
			sb_val[scrollbarh] = current_song.starta
			if (current_song.loopmax != 0) {
				if (timestoloop < 0) {
					playing = 0
					current_song.marker_pos = 0
					current_song.marker_prevpos = 0
					timestoloop = real(current_song.loopmax)
				}
			} 
		}
	    if (current_song.marker_pos > current_song.enda + totalcols) {
	        current_song.marker_pos = current_song.enda + totalcols
	        playing = 0
	    }
	    if (marker_end && current_song.marker_pos >= current_song.section_end && current_song.marker_prevpos < current_song.section_end) {
	        current_song.marker_pos = current_song.section_end
	        playing = 0
	    }
	    if (marker_follow = 1 || isplayer) {
	        if (marker_pagebypage = 1 && !isplayer) {
	            if (floor(current_song.marker_pos) >= current_song.starta + totalcols - 1 && current_song.starta < current_song.enda) {
	                current_song.starta = current_song.marker_pos - 1
	                current_song.starta = median(0, current_song.starta, current_song.enda)
	                sb_val[scrollbarh] = current_song.starta
	            }
	            if (floor(current_song.marker_pos) < current_song.starta + 1 && forward = -1 && current_song.starta > 0) {
	                current_song.starta = floor(current_song.marker_pos) - totalcols + 1
	                current_song.starta = median(0, current_song.starta, current_song.enda)
	                sb_val[scrollbarh] = current_song.starta
	            }
	        } else {
	            current_song.starta = median(0, current_song.marker_pos - ceil(totalcols / 2) * !isplayer, current_song.enda)
	            sb_val[scrollbarh] = current_song.starta
	        }
	    }
	}

	current_song.marker_pos = median(0, current_song.marker_pos, current_song.enda + totalcols)
	
	draw_set_color(0)
	draw_set_alpha(0.2 * dropalpha)
	draw_roundrect_ext(0, 0, 530, 90, 20, 20, 0)
	draw_set_alpha(dropalpha)

	// Tabs

	// Icons
	xx = 6
	yy = 23 + song_tab_offset
	if (language != 1) {
		if (draw_icon(icons.PLAY + playing, xx, yy, "Play / Pause song", 0, 0)) toggle_playing(totalcols) timestoloop = real(current_song.loopmax)
		if (isplayer && !dropmode) if (draw_icon(icons.PLAY + playing, centerx - 12, centery + 50, "Play / Pause song", 0, 0)) toggle_playing(totalcols) timestoloop = real(current_song.loopmax)
		xx += 25
		if (draw_icon(icons.STOP, xx, yy, "Stop song", 0, 0)) {playing = 0 current_song.marker_pos = 0 current_song.marker_prevpos = 0 timestoloop = real(current_song.loopmax) remove_emitters_all_schedule = 1} xx += 25
		if (isplayer && !dropmode) if (draw_icon(icons.STOP, centerx - 12 - 100, centery + 50, "Stop song", 0, 0)) {playing = 0 current_song.marker_pos = 0 current_song.marker_prevpos = 0 timestoloop = real(current_song.loopmax) remove_emitters_all_schedule = 1}
		forward = 0
		if (draw_icon(icons.BACK, xx, yy, "Rewind song", 0, 0)) {forward = -1} xx += 25
		if (isplayer && !dropmode) if (draw_icon(icons.BACK, centerx - 12 - 50, centery + 50, "Rewind song", 0, 0)) {forward = -1}
		if (draw_icon(icons.FORWARD, xx, yy, "Fast-forward song", 0, 0)) {forward = 1} xx += 25
		if (isplayer && !dropmode) if (draw_icon(icons.FORWARD, centerx - 12 + 50, centery + 50, "Fast-forward song", 0, 0)) {forward = 1}
		if (!isplayer) if (draw_icon(icons.RECORD, xx, yy, "Record key presses", 0, playing > 0 && record)) {playing = 0.25 record=!record} if (!isplayer) xx += 25 
		if (draw_icon(icons.LOOP_INACTIVE + current_song.loop_session, xx, yy, "Toggle looping", 0, 0)) current_song.loop_session = !current_song.loop_session if (!isplayer) xx += 25
		if (isplayer && !dropmode) if (draw_icon(icons.LOOP_INACTIVE + current_song.loop_session, centerx - 12 + 100, centery + 50, "Toggle looping", 0, 0)) current_song.loop_session = !current_song.loop_session if (!isplayer)
		if metronome {
			if (metronome_played == -1 || (metronome_played - 1) mod 8 == 0) metricon = icons.METRONOME_1
			else metricon = icons.METRONOME_2
		} else {
			metricon = icons.METRONOME_INACTIVE
		}
		if (!isplayer) if(draw_icon(metricon, xx, yy, "Toggle metronome", 0, 0)) metronome = !metronome
		xx += 25 + 4
		if (playing = 0) record = 0
		draw_separator(xx, yy + 3) xx += 4
		if (!isplayer) if (draw_icon(icons.EDITMODE_KEY, xx, yy, "Edit note key", 0, editmode = 0)) {editmode = 0} if (!isplayer) xx += 25
		if (!isplayer) if (draw_icon(icons.EDITMODE_VEL, xx, yy, "Edit note velocity", 0, editmode = 1)) {editmode = 1}  if (!isplayer) xx += 25
		if (!isplayer) if (draw_icon(icons.EDITMODE_PAN, xx, yy, "Edit note panning", 0, editmode = 2)) {editmode = 2} if (!isplayer) xx += 25
		if (!isplayer) if (draw_icon(icons.EDITMODE_PIT, xx, yy, "Edit note pitch", 0, editmode = 3)) {editmode = 3} if (!isplayer) xx += 25 + 4
		if (!isplayer) draw_separator(xx, yy + 3) if (!isplayer) xx += 4
	} else {
		if (draw_icon(icons.PLAY + playing, xx, yy, "播放 / 暂停", 0, 0)) toggle_playing(totalcols) timestoloop = real(current_song.loopmax)
		if (isplayer && !dropmode) if (draw_icon(icons.PLAY + playing, centerx - 12, centery + 50, "播放 / 暂停", 0, 0)) toggle_playing(totalcols) timestoloop = real(current_song.loopmax)
		xx += 25
		if (draw_icon(icons.STOP, xx, yy, "停止歌曲", 0, 0)) {playing = 0 current_song.marker_pos = 0 current_song.marker_prevpos = 0 timestoloop = real(current_song.loopmax) remove_emitters_all_schedule = 1} xx += 25
		if (isplayer && !dropmode) if (draw_icon(icons.STOP, centerx - 12 - 100, centery + 50, "停止歌曲", 0, 0)) {playing = 0 current_song.marker_pos = 0 current_song.marker_prevpos = 0 timestoloop = real(current_song.loopmax) remove_emitters_all_schedule = 1}
		forward = 0
		if (draw_icon(icons.BACK, xx, yy, "快退", 0, 0)) {forward = -1} xx += 25
		if (isplayer && !dropmode) if (draw_icon(icons.BACK, centerx - 12 - 50, centery + 50, "快退", 0, 0)) {forward = -1}
		if (draw_icon(icons.FORWARD, xx, yy, "快进", 0, 0)) {forward = 1} xx += 25
		if (isplayer && !dropmode) if (draw_icon(icons.FORWARD, centerx - 12 + 50, centery + 50, "快进", 0, 0)) {forward = 1}
		if (!isplayer) if (draw_icon(icons.RECORD, xx, yy, "录制按键", 0, playing > 0 && record)) {playing = 0.25 record=!record} if (!isplayer) xx += 25 
		if (draw_icon(icons.LOOP_INACTIVE + current_song.loop_session, xx, yy, "开关循环", 0, 0)) current_song.loop_session = !current_song.loop_session if (!isplayer) xx += 25
		if (isplayer && !dropmode) if (draw_icon(icons.LOOP_INACTIVE + current_song.loop_session, centerx - 12 + 100, centery + 50, "开关循环", 0, 0)) current_song.loop_session = !current_song.loop_session if (!isplayer)
		if metronome {
			if (metronome_played == -1 || (metronome_played - 1) mod 8 == 0) metricon = icons.METRONOME_1
			else metricon = icons.METRONOME_2
		} else {
			metricon = icons.METRONOME_INACTIVE
		}
		if (!isplayer) if(draw_icon(metricon, xx, yy, "开关节拍器", 0, 0)) metronome = !metronome
		xx += 25 + 4
		if (playing = 0) record = 0
		draw_separator(xx, yy + 3) xx += 4
		if (!isplayer) if (draw_icon(icons.EDITMODE_KEY, xx, yy, "音调模式", 0, editmode = 0)) {editmode = 0} if (!isplayer) xx += 25
		if (!isplayer) if (draw_icon(icons.EDITMODE_VEL, xx, yy, "音量模式", 0, editmode = 1)) {editmode = 1}  if (!isplayer) xx += 25
		if (!isplayer) if (draw_icon(icons.EDITMODE_PAN, xx, yy, "声道模式", 0, editmode = 2)) {editmode = 2} if (!isplayer) xx += 25
		if (!isplayer) if (draw_icon(icons.EDITMODE_PIT, xx, yy, "音高模式", 0, editmode = 3)) {editmode = 3} if (!isplayer) xx += 25 + 4
		if (!isplayer) draw_separator(xx, yy + 3) if (!isplayer) xx += 4
	}

	// Expandable instrument box
	var ins_count = ds_list_size(current_song.instrument_list)
	var ins_icons = median(5, ceil((rw - 920) / 25), ins_count)
	if (ins_icons = ins_count - 1) ins_icons += 1
	var ins_rows = ceil(ins_count / ins_icons)
	if (aa = 2 && mouse_check_button_released(mb_left) && windowsound) {
		play_sound(soundding, 45, 100, 100, 0)
	}
	xx += 8
	var mastervolprev = mastervol
	mastervol = floor(draw_dragbar(mastervol, 1, xx, yy + 10, 100, 2, clamp(mouse_x - xx, 0, 100), condstr(language != 1, "Master Volume: ", "主音量：") + string(floor(mastervol * 100)), 0) * 100 + 0.5) / 100
	if (mastervolprev != mastervol && audio_is_playing(current_song.reference_audio)) audio_sound_gain(current_song.reference_audio, (current_song.reference_volume * mastervol) / 100, 0)
	if (mouse_rectangle(xx - 11, yy, 122, 22) && window = 0) {
		volume_scroll = 1
		if (mouse_wheel_up() && mastervol + 0.02 <= 1) {mastervol += 0.02; if (audio_is_playing(current_song.reference_audio)) audio_sound_gain(current_song.reference_audio, (current_song.reference_volume * mastervol) / 100, 0)}
		if (mouse_wheel_down() && mastervol - 0.02 >= 0) {mastervol -= 0.02; if (audio_is_playing(current_song.reference_audio)) audio_sound_gain(current_song.reference_audio, (current_song.reference_volume * mastervol) / 100, 0)}
	} else {
		volume_scroll = 0
	}
	draw_set_alpha(1)

	// Compatible
	

	draw_set_alpha(dropalpha)
	// Marker position
	if (theme != 3) draw_set_halign(fa_right)
	draw_theme_color()
	draw_theme_font(font_info_med_bold)
	if (theme != 3) draw_text_dynamic(93, 52 + song_tab_offset, time_str(get_seconds_from_tick(current_song.marker_pos)))
	else draw_text_dynamic(93 - 84, 52 + song_tab_offset, time_str(get_seconds_from_tick(current_song.marker_pos)))

	// Song length
	draw_theme_font(font_small)
	if (theme != 3) draw_text_dynamic(93, 69 + song_tab_offset, "/ " + time_str(get_seconds_from_tick(current_song.enda)))
	else draw_text_dynamic(93 - 67, 69 + song_tab_offset, "/ " + time_str(get_seconds_from_tick(current_song.enda)))
	draw_theme_font(font_main)
	draw_set_halign(fa_left)
	draw_set_alpha(1)
		
	current_song = songs[song]
	draw_set_alpha(dropalpha)
	current_song.marker_pos = draw_dragbar(current_song.marker_pos, current_song.enda + totalcols, 93 - 84 + 100, 52 + 15, 400, 1, time_str(get_seconds_from_tick(clamp(((mouse_x - (93 - 84 + 100)) / 400) * current_song.enda, 0, current_song.enda))), condstr(language != 1, "Song Position", "当前位置"), 0)
	draw_set_alpha(1)
	if (mouse_x != mouse_xprev || mouse_y != mouse_yprev || mouse_rectangle(0, 0, 530, 90) || window != 0) {
		dropalpha = 1
		dropalphawait = current_time
	} else if (current_time - dropalphawait >= 1500 && dropalpha > 0) {
		if (dropalpha - (1 / (room_speed * currspeed)) * 2 > 0) dropalpha -= (1 / (room_speed * currspeed)) * 2
		else dropalpha = 0
	}
	current_song.starta = current_song.marker_pos
	draw_set_halign(fa_left)

	draw_set_halign(fa_left)
	
	// Song Tabs

	// Piano

	// End selecting

	if (mouse_check_button_released(mb_left)) {
	    w_isdragging = 0
	}
	if (window = w_releasemouse && !mouse_check_button(mb_left)) {window = 0 windowopen = 0}
	draw_windows()
	if (showmsg) draw_msg()
	if (rainbowtoggle) draw_accent_rainbow()

	// Draw update progress bar
	
	// Draw song download progress bar
	
	// Draw debug overlay
	if (debug_overlay) draw_debug_overlay()
	if (logs_overlay) draw_logs_overlay(500, 40)
	
	if (display_mouse_get_x() - window_get_x() >= 0 && display_mouse_get_y() - window_get_y() >= 0 && display_mouse_get_x() - window_get_x() < 0 + window_width && display_mouse_get_y() - window_get_y() < 0 + window_height) window_set_cursor(curs)
	mouse_xprev = mouse_x
	mouse_yprev = mouse_y
	
	if (remove_emitters_all_schedule) remove_emitters_all()
	
	// Detect when windows have changed
	/*if window != prevwindow {
		show_debug_message(string(window) + " " + string(prevwindow))
	}*/
	prevwindow = window
}
