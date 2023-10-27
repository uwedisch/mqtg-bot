package models

import (
	"gorm.io/gorm"
)

type DbUserRole struct {
	gorm.Model
	DbUserID uint
	Role     string `gorm:"type:varchar(255)"`
}
