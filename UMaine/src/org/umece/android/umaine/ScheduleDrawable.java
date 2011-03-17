package org.umece.android.umaine;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.View;

public class ScheduleDrawable extends View {
	Context mContext;
	private static final int start_time = 8;
	private static final int end_time = 20;
	private Color[] m;
	private Color[] t;
	private Color[] w;
	private Color[] h;
	private Color[] f;
	private Semester semester;
	private List<Rect> rect_queue;
	private List<Color> color_queue;
	public int x, y;
	public int each_width;
	
	public ScheduleDrawable(Context context, AttributeSet attrs) {
		super(context, attrs);
		mContext = context;
		this.semester = null;
		m = new Color[(end_time - start_time) * 2];
		t = new Color[(end_time - start_time) * 2];
		w = new Color[(end_time - start_time) * 2];
		h = new Color[(end_time - start_time) * 2];
		f = new Color[(end_time - start_time) * 2];
		
		rect_queue = new ArrayList<Rect>();
		color_queue = new ArrayList<Color>();
	}
	
	public ScheduleDrawable(Context context) {
		this(context, (Semester)null);
	}

	public ScheduleDrawable(Context context, Semester sem) {
		super(context);
		mContext = context;
		this.semester = sem;
		m = new Color[(end_time - start_time) * 2];
		t = new Color[(end_time - start_time) * 2];
		w = new Color[(end_time - start_time) * 2];
		h = new Color[(end_time - start_time) * 2];
		f = new Color[(end_time - start_time) * 2];
		
		rect_queue = new ArrayList<Rect>();
		color_queue = new ArrayList<Color>();
	}
	
	public void onChange() {
		clearArrays();
		fillArray();
		drawSchedule();
		
		invalidate();
	}
	
	public int getQueueSize() {
		if (rect_queue.size() != color_queue.size()) {
			throw new RuntimeException();
		}
		
		return rect_queue.size();
	}
	
	private void drawSchedule() {
		rect_queue.clear();
		color_queue.clear();
		int start_rect = (int)(.95 * x);
		int end_rect = (int)(.05 * x);
		Rect m_rect = new Rect(start_rect, (int)(y * .10), end_rect, (int)(y * .20));
		Rect t_rect = new Rect(start_rect, (int)(y * .30), end_rect, (int)(y * .40));
		Rect w_rect = new Rect(start_rect, (int)(y * .50), end_rect, (int)(y * .60));
		Rect h_rect = new Rect(start_rect, (int)(y * .70), end_rect, (int)(y * .80));
		Rect f_rect = new Rect(start_rect, (int)(y * .90), end_rect, (int)(y * 1.00));
		Color white = Color.getColor("WHITE");
		
		rect_queue.add(m_rect);
		rect_queue.add(t_rect);
		rect_queue.add(w_rect);
		rect_queue.add(h_rect);
		rect_queue.add(f_rect);
		color_queue.add(white);
		color_queue.add(white);
		color_queue.add(white);
		color_queue.add(white);
		color_queue.add(white);
		
		addRects(m_rect, m);
		addRects(t_rect, t);
		addRects(w_rect, w);
		addRects(h_rect, h);
		addRects(f_rect, f);
	}

	private void addRects(Rect mRect, Color[] colors) {
		int rect_width = mRect.left - mRect.right;
		each_width = (rect_width) / colors.length;
		int i;
		
		for (i = 0; i < colors.length; i++) {
			rect_queue.add(new Rect(
					(each_width * i) + 1 + mRect.right,
					mRect.top + 1,
					(each_width * (i + 1)) - 1 + mRect.right,
					mRect.bottom - 1));
			color_queue.add(colors[i]);
		}
	}

	private void fillArray() {
		HashMap<Course, Color> colors = new HashMap<Course, Color>();
		int i = 2;
		
		if (semester == null) return;
		
		for (Course course : semester.getCourses()) {
			colors.put(course, Color.getColor(i++));
			if (i == Color.getMaxId()) i = 2;
		}
		
		for (Course course : semester.getCourses()) {
			int start = parseTime(course.getTimes().split("-")[0]);
			int end = parseTime(course.getTimes().split("-")[1]);
			
			int index = ((start / 100) * 2) + (((start % 100) > 0)?1:0);
			int end_index = (((end + 69) / 100) * 2) + (((end % 100) > 0)?1:0);
			index -= 16;
			end_index -= 16;
			
			while ((index > 0) &&
					(index < m.length) &&
					(index <= end_index)) {
//				if (course.getDays().contains("M")) {
					m[index] = colors.get(course);
//				} else if (course.getDays().contains("T")) {
					t[index] = colors.get(course);
//				} else if (course.getDays().contains("W")) {
					w[index] = colors.get(course);
//				} else if (course.getDays().contains("Th")) {
					h[index] = colors.get(course);
//				} else if (course.getDays().contains("F")) {
					f[index] = colors.get(course);
//				}
				
				index++;
			}
		}
	}
	
	private int parseTime(String string) {
		boolean pm = false;
		
		if (string.contains("PM")) {
			pm = true;
		}
		String time = string;//.split(" ")[0];
		int val = 100 * Integer.parseInt(time.split(":")[0]);
		if (pm && (val != 1200)) {
			val += 1200;
		} else if (!pm && (val == 1200)) {
			val = 0;
		}
		
		val += Integer.parseInt(time.split(":")[1]);
		
		return val;
	}

	private void clearArrays() {
		int i;
		for (i = 0; i < m.length; i++) {
			m[i] = Color.getColor("BLACK");
			t[i] = Color.getColor("BLACK");
			w[i] = Color.getColor("BLACK");
			h[i] = Color.getColor("BLACK");
			f[i] = Color.getColor("BLACK");
		}
	}

	public void setSemester(Semester sem) {
		semester = sem;
		if (semester != null) {
			onChange();
		}
	}
	
	public Semester getSemester() {
		return semester;
	}
	
	@Override
	protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		x = MeasureSpec.getSize(widthMeasureSpec);
		y = MeasureSpec.getSize(heightMeasureSpec);
		super.onMeasure(widthMeasureSpec, heightMeasureSpec);
		
		onChange();
	}

	@Override
	protected void onDraw(Canvas canvas) {
		drawQueue(canvas);
	}

	private void drawQueue(Canvas canvas) {
		int i;
		
		if (rect_queue.size() != color_queue.size()) {
			throw new RuntimeException();
		}
		
		for (i = 0; i < rect_queue.size(); i++) {
			drawRect(rect_queue.get(i), color_queue.get(i), canvas);
		}
	}

	private void drawRect(Rect rect, Color color, Canvas canvas) {
		Paint paint = new Paint();
		paint.setStrokeWidth(3);
		paint.setColor(color.getColor());
		
		canvas.drawRect(rect, paint);
	}

}
