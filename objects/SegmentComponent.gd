class_name SegmentComponent
extends Node

var next_segment: SegmentComponent: set = set_next_segment
var prev_segment: SegmentComponent: set = set_prev_segment

func set_next_segment(segment: SegmentComponent):
	next_segment = segment

func set_prev_segment(segment: SegmentComponent):
	prev_segment = segment
