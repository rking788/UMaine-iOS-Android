package org.umece.android.umaine;

import java.util.HashMap;
import java.util.Map;

public enum Color {
	BLACK(0, 0xFF000000),
	MAINE_BLUE(1, 0xc0003263),
	LIGHT_BLUE(2, 0xffb0d7ff),
	WHITE_BLUE(3, 0xffdeeeff),
	GRAY(4, 0x77666666),
	DARKGRAY(5, 0x77121212),
	RED(6, 0xFFFF0000),
	BLUE(7, 0xFF0000FF),
	GREEN(8, 0xFF00FF00),
	FUSCIA(9, 0xFFFF00FF),
	ORANGE(10, 0xFFFFA500),
	YELLOW(11, 0xFFFFFF00),
	TERQUOISE(12, 0xFF00FFFF),
	WHITE(13, 0xFFFFFFFF);
	
	private final int id;
	private final int color;
    private static final Map<Integer, Color> lookupId = new HashMap<Integer, Color>();
    private static final Map<String, Color> lookupName = new HashMap<String, Color>();
    private static final Map<Integer, Color> lookupColor = new HashMap<Integer, Color>();
	
	private Color(final int id, final int color) {
		this.id = id;
		this.color = color;
	}
	
	public int getId() {
		return id;
	}
	
	public int getColor() {
		return color;
	}
	
	public static Color getColor(final int id) {
		return lookupId.get(id);
	}
	
	public static Color getColor(final int color, final int color_2) {
		return lookupColor.get(color);
	}

	public static Color getColor(final String name) {
		return lookupName.get(name);
	}
	
	public static int getMaxId() {
		return lookupId.size() - 1;
	}

    static {
        for (Color color : values()) {
            lookupId.put(color.getId(), color);
            lookupColor.put(color.getColor(), color);
            lookupName.put(color.name(), color);
        }
    }
}
