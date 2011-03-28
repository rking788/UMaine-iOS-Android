package org.umece.android.umaine;

import java.util.HashMap;
import java.util.Map;

public enum Color {
	BLACK(0, 0xFF000000),
	GRAY(1, 0x77666666),
	RED(2, 0xFFFF0000),
	BLUE(3, 0xFF0000FF),
	GREEN(4, 0xFF00FF00),
	FUSCIA(5, 0xFFFF00FF),
	ORANGE(6, 0xFFFFA500),
	YELLOW(7, 0xFFFFFF00),
	TERQUOISE(8, 0xFF00FFFF),
	WHITE(9, 0xFFFFFFFF);
	
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
