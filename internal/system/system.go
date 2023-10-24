package system

import (
	"gorm.io/gorm"
	"log"
	"mqtg-bot/internal/models"
	"sync"
)

type System struct {
	sync.RWMutex
	db     *gorm.DB
	Public bool
}

func InitSystem(db *gorm.DB) *System {
	return &System{
		db: db,
	}
}

func (um *System) LoadSystem() {
	var dbSystem models.DbSystem

	log.Printf("Query system properties")
	um.db.First(&dbSystem)

	if dbSystem.ID == 0 {
		// No system information set
		var dbSystem models.DbSystem
		dbSystem.Public = false
		um.db.Create(&dbSystem)

		um.Public = dbSystem.Public
	} else {
		um.Public = dbSystem.Public
	}
	log.Printf("System is configured as public: %v", um.Public)
}
