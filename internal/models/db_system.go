package models

import (
	"gorm.io/gorm"
)

type DbSystem struct {
	gorm.Model
	Public bool
}
