--- i3bar/src/xcb.c	2021-02-01 01:54:35.000000000 -0700
+++ xcb.c	2021-05-09 09:37:52.651933000 -0700
@@ -106,14 +106,17 @@
 };
 struct xcb_colors_t colors;
 
+/* Margin above/below buttons */
+static const int ws_margin_px = 5;
+
 /* Horizontal offset between a workspace label and button borders */
-static const int ws_hoff_px = 4;
+static const int ws_hoff_px = 5;
 
 /* Vertical offset between a workspace label and button borders */
-static const int ws_voff_px = 3;
+static const int ws_voff_px = 5;
 
 /* Offset between two workspace buttons */
-static const int ws_spacing_px = 1;
+static const int ws_spacing_px = 5;
 
 /* Offset between the statusline and 1) workspace buttons on the left
  *                                   2) the tray or screen edge on the right */
@@ -238,6 +241,8 @@
  */
 static void draw_statusline(i3_output *output, uint32_t clip_left, bool use_focus_colors, bool use_short_text) {
     struct status_block *block;
+    int margin = logical_px(ws_margin_px);
+    int height = bar_height - 2 * logical_px(1) - 2 * margin;
 
     color_t bar_color = (use_focus_colors ? colors.focus_bar_bg : colors.bar_bg);
     draw_util_clear_surface(&output->statusline_buffer, bar_color);
@@ -291,20 +296,26 @@
             }
 
             /* Draw the border. */
-            draw_util_rectangle(&output->statusline_buffer, border_color,
-                                x, logical_px(1),
-                                full_render_width,
-                                bar_height - logical_px(2));
+            draw_util_rectangle(&output->statusline_buffer,     // surface
+                                border_color,                   // color
+                                x,                              // x
+                                logical_px(1) + margin,         // y
+                                full_render_width, // w
+                                bar_height - logical_px(2) - 2 * margin);    // h
 
             /* Draw the background. */
-            draw_util_rectangle(&output->statusline_buffer, bg_color,
-                                x + has_border * logical_px(block->border_left),
-                                logical_px(1) + has_border * logical_px(block->border_top),
-                                full_render_width - has_border * logical_px(block->border_right + block->border_left),
-                                bar_height - has_border * logical_px(block->border_bottom + block->border_top) - logical_px(2));
+            draw_util_rectangle(&output->statusline_buffer,     // surface
+                                bg_color,                       // color
+                                x + has_border * logical_px(block->border_left), // x
+                                logical_px(1) + has_border * logical_px(block->border_top) + margin, // y
+                                full_render_width - has_border * logical_px(block->border_right + block->border_left), // w
+                                bar_height - has_border * logical_px(block->border_bottom + block->border_top) - logical_px(2) - 2 * margin); // h
         }
 
-        draw_util_text(text, &output->statusline_buffer, fg_color, bg_color,
+        draw_util_text(text,
+                       &output->statusline_buffer,
+                       fg_color,
+                       bg_color,
                        x + render->x_offset + has_border * logical_px(block->border_left),
                        bar_height / 2 - font.height / 2,
                        render->width - has_border * logical_px(block->border_left + block->border_right));
@@ -527,7 +538,7 @@
     const bool event_is_release = (event->response_type & ~0x80) == XCB_BUTTON_RELEASE;
 
     int32_t x = event->event_x >= 0 ? event->event_x : 0;
-    int workspace_width = 0;
+    int workspace_width = 1.5 * ws_margin_px;
     i3_ws *cur_ws = NULL, *clicked_ws = NULL, *ws_walk;
 
     TAILQ_FOREACH (ws_walk, walk->workspaces, tailq) {
@@ -1361,10 +1372,10 @@
      * based on the font size.
      */
     if (config.bar_height <= 0)
-        bar_height = font.height + 2 * logical_px(ws_voff_px);
+        bar_height = font.height + 2 * logical_px(ws_voff_px) + 2 * logical_px(ws_margin_px);
     else
         bar_height = config.bar_height;
-    icon_size = bar_height - 2 * logical_px(config.tray_padding);
+    icon_size = bar_height - 2 * logical_px(config.tray_padding) - 2 * logical_px(ws_margin_px);
 
     if (config.separator_symbol)
         separator_symbol_width = predict_text_width(config.separator_symbol);
@@ -1982,13 +1993,14 @@
  */
 static void draw_button(surface_t *surface, color_t fg_color, color_t bg_color, color_t border_color,
                         int x, int width, int text_width, i3String *text) {
-    int height = bar_height - 2 * logical_px(1);
+    int margin = logical_px(ws_margin_px);
+    int height = bar_height - 2 * logical_px(1) - 2 * margin;
 
     /* Draw the border of the button. */
-    draw_util_rectangle(surface, border_color, x, logical_px(1), width, height);
+    draw_util_rectangle(surface, border_color, x, logical_px(1) + margin, width, height);
 
     /* Draw the inside of the button. */
-    draw_util_rectangle(surface, bg_color, x + logical_px(1), 2 * logical_px(1),
+    draw_util_rectangle(surface, bg_color, x + logical_px(1), 2 * logical_px(1) + margin,
                         width - 2 * logical_px(1), height - 2 * logical_px(1));
 
     draw_util_text(text, surface, fg_color, bg_color, x + (width - text_width) / 2,
@@ -2007,7 +2019,7 @@
 
     i3_output *outputs_walk;
     SLIST_FOREACH (outputs_walk, outputs, slist) {
-        int workspace_width = 0;
+        int workspace_width = 1.5 * ws_margin_px;
 
         if (!outputs_walk->active) {
             DLOG("Output %s inactive, skipping...\n", outputs_walk->name);
@@ -2090,7 +2102,7 @@
             }
 
             int16_t visible_statusline_width = MIN(statusline_width, max_statusline_width);
-            int x_dest = outputs_walk->rect.w - tray_width - logical_px((tray_width > 0) * sb_hoff_px) - visible_statusline_width;
+            int x_dest = outputs_walk->rect.w - tray_width - logical_px((tray_width > 0) * sb_hoff_px) - visible_statusline_width - logical_px(ws_margin_px) * 2;
 
             draw_statusline(outputs_walk, clip_left, use_focus_colors, use_short_text);
             draw_util_copy_surface(&outputs_walk->statusline_buffer, &outputs_walk->buffer, 0, 0,
