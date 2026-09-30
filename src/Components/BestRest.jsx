import React from 'react'
import './BestRes.css'

function BestRest() {
  return (
    <div className='d-flex justify-content-center align-items-center mt-5 mb-5'>
        <div style={{width:"85%"}}>
            <h4 className='fw-bold'>Best Places to Eat Across Andhra</h4>
            <div className='buttons-grp d-flex justify-content-between'>
                <button>Best Restaurant in Amalapuram</button>
                <button>Best Restaurant in Kakinada</button>
                <button>Best Restaurant in Rajahmundry</button>
                <button>Best Restaurant in Vijayawada</button>
            </div>

            <div className='buttons-grp d-flex justify-content-between mt-3'>
                <button>Best Restaurant in Visakhapatnam</button>
                <button>Best Restaurant in Guntur</button>
                <button>Best Restaurant in Eluru</button>
                <button>Best Restaurant in Tirupati</button>
            </div>

            <div className='buttons-grp d-flex justify-content-between mt-3'>
                <button>Best Restaurant in Machilipatnam</button>
                <button>Best Restaurant in Nellore</button>
                <button>Best Restaurant in Anantapur</button>
                <button>Show More <i className="fa-solid fa-angle-down"></i></button>
            </div>

            <h4 style={{marginTop:"80px"}} className='fw-bold'>Best Cuisines Near Me</h4>

            <div className='buttons-grp d-flex justify-content-between'>
                <button>Chinese Food Near Me</button>
                <button>South Indian Food Near Me</button>
                <button>Andhra Meals Near Me</button>
                <button>Sea Food Near Me</button>
            </div>

            <div className='buttons-grp d-flex justify-content-between mt-3'>
                <button>Biriyani Near Me</button>
                <button>North Indian Food Near Me</button>
                <button>Veg Combo Near Me</button>
                <button>Fast Food Near Me</button>
            </div>

            <div className='buttons-grp d-flex justify-content-between mt-3'>
                <button>Bakery Near Me</button>
                <button>Pizza Near Me</button>
                <button>Healthy Food Near Me</button>
                <button>Show More <i className="fa-solid fa-angle-down"></i></button>
            </div>

            <h4 style={{marginTop:"80px"}} className='fw-bold'>Explore Every Restaurants Near Me</h4>
            <div className='buttons-grps d-flex justify-content-between mt-3'>
                <button>Explore Restaurants Near Me</button>
                <button>Explore Top Rated Restaurants Near Me</button>
            </div>
        </div>
    </div>
  )
}

export default BestRest