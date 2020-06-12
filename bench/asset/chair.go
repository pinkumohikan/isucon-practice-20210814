package asset

import (
	"encoding/json"
	"sync/atomic"
)

type JSONChair struct {
	ID          int64  `json:"id"`
	Name        string `json:"name"`
	Description string `json:"description"`
	Thumbnail   string `json:"thumbnail"`
	Price       int64  `json:"price"`
	Height      int64  `json:"height"`
	Width       int64  `json:"width"`
	Depth       int64  `json:"depth"`
	Color       string `json:"color"`
	Features    string `json:"features"`
	ViewCount   int64  `json:"view_count"`
	Kind        string `json:"kind"`
	Stock       int64  `json:"stock"`
}

type Chair struct {
	ID          int64
	Name        string
	Description string
	Thumbnail   string
	Price       int64
	Height      int64
	Width       int64
	Depth       int64
	Color       string
	Features    string
	Kind        string

	viewCount int64
	stock     int64
}

func (c Chair) MarshalJSON() ([]byte, error) {

	m := JSONChair{
		ID:          c.ID,
		Name:        c.Name,
		Description: c.Description,
		Thumbnail:   c.Thumbnail,
		Price:       c.Price,
		Height:      c.Height,
		Width:       c.Width,
		Depth:       c.Depth,
		Color:       c.Color,
		Features:    c.Features,
		ViewCount:   c.viewCount,
		Kind:        c.Kind,
		Stock:       c.stock,
	}

	return json.Marshal(m)
}

func (c *Chair) UnmarshalJSON(data []byte) error {
	var jc JSONChair

	err := json.Unmarshal(data, &jc)
	if err != nil {
		return err
	}

	c.ID = jc.ID
	c.Name = jc.Name
	c.Description = jc.Description
	c.Thumbnail = jc.Thumbnail
	c.Price = jc.Price
	c.Height = jc.Height
	c.Width = jc.Width
	c.Depth = jc.Depth
	c.Color = jc.Color
	c.Features = jc.Features
	c.viewCount = jc.ViewCount
	c.Kind = jc.Kind
	c.stock = jc.Stock

	return nil
}

func (c1 *Chair) Equal(c2 *Chair) bool {
	return c1.ID == c2.ID
}

func (c *Chair) GetViewCount() int64 {
	return atomic.LoadInt64(&(c.viewCount))
}

func (c *Chair) GetStock() int64 {
	return atomic.LoadInt64(&(c.stock))
}

func (c *Chair) IncrementViewCount() {
	atomic.AddInt64(&(c.viewCount), 1)
}

func (c *Chair) DecrementStock() {
	atomic.AddInt64(&(c.stock), -1)
}